<?php

use erede\model\TransactionRequest;
use erede\model\TransactionResponse;

require_once(dirname(__FILE__).'/../../adqr/log.php');
require_once(dirname(__FILE__).'/../../adqr/Classloader.php');

class ERedeModuloIntegrationModuleFrontController extends ModuleFrontController
{
	/**
	 * @see FrontController::postProcess()
	 */
	public function postProcess() {
		$cart = $this->context->cart;
		if ($cart->id_customer == 0 || $cart->id_address_delivery == 0 || $cart->id_address_invoice == 0 || !$this->module->active)
			Tools::redirect('index.php?controller=order&step=1');

		// Check that this payment option is still available in case the customer changed his address just before the end of the checkout process
		$authorized = false;
		foreach (Module::getPaymentModules() as $module) {
			if ($module['name'] == 'eredemodulo') {
				$authorized = true;
				break;
			}
		}
		if (!$authorized)
			die($this->module->l('Este método de pagamento não está disponível.', 'eredemodulo'));

		$customer = new Customer($cart->id_customer);
		if (!Validate::isLoadedObject($customer))
			Tools::redirect('index.php?controller=order&step=1');

		$currency = $this->context->currency;
		$total = (float)$cart->getOrderTotal(true, Cart::BOTH);		
		
		$transactionRequest = new TransactionRequest();
		$transactionRequest->setCardHolderName(Tools::getValue('EREDE_CARD_HOLDER_NAME'));
		$transactionRequest->setCardNumber(preg_replace('/[^0-9]/', '', Tools::getValue('EREDE_CARD_NUMBER')));
		$transactionRequest->setExpirationMonth(Tools::getValue('EREDE_MONTH_EXPIRATION'));
		$document = preg_replace('/[^0-9]/', '', Tools::getValue('EREDE_DOCUMENT_CARD_HOLDER'));
		$transactionRequest->setExpirationYear(Tools::getValue('EREDE_YEAR_EXPIRATION'));
		$transactionRequest->setSecurityCode(Tools::getValue('EREDE_CVV'));
		$transactionRequest->setInstallments(Tools::getValue('EREDE_INSTALLMENTS'));
		$transactionRequest->setReference($cart->id);
		$transactionRequest->setAmount(number_format($total, 2, '', ''));
		$transactionRequest->setCapture(false);

		if(Configuration::get('EREDE_AUTOMATIC_CAPTURE') == 'true') {
			$transactionRequest->setCapture(true);
		}

		$softDescriptor = Configuration::get('EREDE_SOFT_DESCRIPTOR');
		if($softDescriptor) {
			$transactionRequest->setSoftDescriptor(Configuration::get('EREDE_SOFT_DESCRIPTOR'));
		}

		$acquirer = new Acquirer(Configuration::get('EREDE_AFFILIATION'), Configuration::get('EREDE_PASSWORD'), Configuration::get('EREDE_ENVIRONMENT'));
		$response = new TransactionResponse();
		$response = $acquirer->authorize($transactionRequest);

		if($response->getReturnCode() == '00') {
			$orderStatus = Configuration::get('EREDE_STATUS_0');
			$orderValid = $this->module->validateOrder($cart->id, $orderStatus, $total, $this->module->displayName, NULL, NULL, (int)$currency->id, false, $customer->secure_key);

			if($transactionRequest->getCapture() == true) {
				$order_id = $this->module->currentOrder;
				$history = new OrderHistory();
				$history->id_order = $order_id;
				$orderStatus = Configuration::get('EREDE_STATUS_1');
				$history->changeIdOrderState($orderStatus, $order_id);
				$this->module->addNewOrderHistory($order_id, $orderStatus, 0);
			}

			$linkValid = $this->linkTransactionToOrder($cart->id, $response->getTid());
			$this->saveLog($transactionRequest, $response, $document);				
			Tools::redirect('index.php?controller=order-confirmation&id_cart='.$cart->id.'&id_module='.$this->module->id.'&id_order='.$this->module->currentOrder.'&key='.$customer->secure_key);
		}
		else {
			$order_id = $this->module->currentOrder;
			$orderStatus = Configuration::get('PS_OS_CANCELED');
			$orderValid = $this->module->validateOrder($cart->id, $orderStatus, $total, $this->module->displayName, NULL, NULL, (int)$currency->id, false, $customer->secure_key);

			$this->saveLog($transactionRequest, $response, $document);
			Tools::redirect('index.php?controller=order-confirmation&id_cart='.$cart->id.'&id_module='.$this->module->id.'&id_order='.$this->module->currentOrder.'&key='.$customer->secure_key);
		}
	}

	private function linkTransactionToOrder($cart_id, $transactionId){
		$tablename = _DB_PREFIX_."orders";
		$sql = "UPDATE $tablename
						SET EREDE_TID = '$transactionId'
						WHERE id_cart = $cart_id";
		$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($sql);
		return $result;
	}

	private function saveLog($transactionRequest, $transactionResponse, $document) {
		$logData = array(
        		"cardholder_name" 		=> $transactionRequest->getCardHolderName(),
        		"card_number" 			=> $transactionResponse->getLast4(),
        		"amount" 				=> (float)$transactionResponse->getAmount()/100,
        		"nsu" 					=> $transactionResponse->getNsu(),
         		"installments" 			=> (int)$transactionResponse->getInstallments(),
        		"cart_id" 				=> $transactionRequest->getReference(),
        		"return_message" 		=>$transactionResponse->getReturnMessage(),
        		"message"	 			=>$transactionResponse->getReturnMessage(),
        		"tid" 					=> $transactionResponse->getTid(),
        		"acquirerStatus" 		=> $transactionResponse->getReturnCode(),
        		"brand" 				=> '',
        		"document" 				=> $document,
        		"step" 					=> "authorize credit",
        		"authorization_number" 	=> $transactionResponse->getAuthorizationCode()
        );

		$log = new Log(Db::getInstance(_PS_USE_SQL_SLAVE_), _DB_PREFIX_);
		
		foreach($logData as $key => $value){
    		$log->{$key} = $value;
    	}

    	$log->insert();
	}
}
?>