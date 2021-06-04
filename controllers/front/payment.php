<?php

class ERedeModuloPaymentModuleFrontController extends ModuleFrontController
{
	/**
	 * @see FrontController::initContent()
	 */
	public function initContent()
	{
		$this->context->controller->addCss($this->module->getPathUri().'views/css/payment.css', 'all');
		$this->context->controller->addJs($this->module->getPathUri().'views/js/jquery.mask.min.js');
		$this->context->controller->addJs($this->module->getPathUri().'views/js/jquery.creditCardValidator.js');
		
		$this->display_column_left = false;
		parent::initContent();

		$cart = $this->context->cart;
		$totalOrder =  $cart->getOrderTotal(true, Cart::BOTH);
		$currencyOrder = $this->context->currency;
		$prefix = $currencyOrder->prefix;

		$currentYear = date("Y");
		$yearRange = array( "" => $this->module->l('ano', 'eredemodulo'));
		for($i = $currentYear; $i <= ($currentYear+10) ; $i++){
			$yearRange[$i] = $i;
		}

		$installmentsRange = array("" => $this->module->l('Selecione...', 'eredemodulo'), "1" => $this->module->l('À Vista ', 'eredemodulo').' '.Tools::displayPrice($totalOrder, $currencyOrder));
		$minValueForInstallment = Configuration::get('EREDE_MIN_VALUE_FOR_INSTALLMENT');
		$totalInstallmentsAllowed = Configuration::get('EREDE_MAX_INSTALLMENTS_NUMBER');
		$minInstallmentValue = Configuration::get('EREDE_MIN_INSTALLMENT_VALUE');

		if($totalOrder >= $minValueForInstallment) {
			for ($i = 2; $i < ($totalInstallmentsAllowed); $i++) {
				$installment = $totalOrder/$i;
				if ($installment < $minInstallmentValue) {
					break;
				}
				$installmentsRange[$i] = $i.$this->module->l('x de ', 'eredemodulo').Tools::displayPrice(round($installment, 2, PHP_ROUND_HALF_UP), $currencyOrder).$this->module->l(' sem juros', 'eredemodulo');
			}
		}

		$this->context->smarty->assign(array(
		  //  'tpl_dir' => 'module:eredemodulo/views/templates/front/',
			'nbProducts' => $cart->nbProducts(),
			'cust_currency' => $cart->id_currency,
			'total' => $totalOrder,
			'this_path' => $this->module->getPathUri(),
			'this_path_bw' => $this->module->getPathUri(),
			'yearRange' => $yearRange,
			'installmentsRange' => $installmentsRange,
			'errorAcquirer' => false,
			'errorAcquirerCounter' => htmlentities('0', ENT_COMPAT, 'UTF-8'),
			'versionCss' => htmlentities('V'.$this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'version' => htmlentities($this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'this_path_ssl' => (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
			.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
		));
		
		try {
    	    /**Funciona*/
    		$this->setTemplate('module:eredemodulo/views/templates/front/payment_execution.tpl');
           
            //	$this->setTemplate(_PS_MODULE_DIR_.'eredemodulo/templates/front/payment_execution.tpl');
            // $this->setTemplate('payment_execution');
            
		} catch (Exception $e) {
            echo 'Exceção capturada: ',  $e->getMessage(), "\n";
        }
	}
}
