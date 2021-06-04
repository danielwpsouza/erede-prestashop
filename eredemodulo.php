<?php

if (!defined('_PS_VERSION_'))
	exit;

require_once(dirname(__FILE__).'/adqr/log.php');
require_once(dirname(__FILE__).'/adqr/Classloader.php');

use PrestaShop\PrestaShop\Core\Payment\PaymentOption;

class eredemodulo extends PaymentModule
{
	private $_html = '';
	private $_postErrors = array();

	public $erede;
	public function __construct(){
		$this->name = 'eredemodulo';
		$this->tab = 'payments_gateways';
		$this->version = '1.0.0';
		$this->currencies = true;
		$this->currencies_mode = 'radio';
		$this->need_instance = 0;
		$this->ps_versions_compliancy = array('min' => '1.5', 'max' => '1.7.7.17');

		parent::__construct();

		$this->page = basename(__file__, '.php');
		$this->displayName = $this->l('e.Rede');
		$this->description = $this->l('Aceite pagamentos via cartão de crédito utilizando o e.Rede');
		$this->confirmUninstall = $this->l('Tem certeza que deseja desinstalar o eRede?');
		$this->author = $this->l('Rede');
		$this->link = new Link();

	}

	public function install()
	{
		if (!parent::install()
				|| !$this->createStates()
				|| !$this->installModuleTab('eRede', 'eRede')
				|| !Configuration::updateValue('EREDE_AFFILIATION', '')
				|| !Configuration::updateValue('EREDE_PASSWORD', '')
				|| !Configuration::updateValue('EREDE_ENVIRONMENT')
				|| !Configuration::updateValue('EREDE_TRANSACTION_TYPE')
				|| !Configuration::updateValue('EREDE_MAX_INSTALLMENTS_NUMBER')
				|| !Configuration::updateValue('EREDE_MIN_VALUE_FOR_INSTALLMENT', '')
				|| !Configuration::updateValue('EREDE_MIN_INSTALLMENT_VALUE', '')
				|| !Configuration::updateValue('EREDE_SOFT_DESCRIPTOR', '')
				|| !$this->registerHook('paymentOptions')
				|| !$this->registerHook('payment')
				|| !$this->registerHook('paymentReturn')
				|| !$this->registerHook('actionOrderHistoryAddAfter')
				|| !Log::createTable(Db::getInstance(_PS_USE_SQL_SLAVE_), _DB_PREFIX_)
				|| !$this->addTransactionIdColumnOnOrders()){
					return false;
			}
			return true;
	}

	public function uninstall()
	{
		if (!parent::uninstall()

			// || !$this->deleteStates()
			|| !$this->uninstallModuleTab('eRede')
			|| !Configuration::deleteByName('EREDE_AFFILIATION')
			|| !Configuration::deleteByName('EREDE_PASSWORD')
			|| !Configuration::deleteByName('EREDE_ENVIRONMENT')
			|| !Configuration::deleteByName('EREDE_TRANSACTION_TYPE')
			|| !Configuration::deleteByName('EREDE_MAX_INSTALLMENTS_NUMBER')
			|| !Configuration::deleteByName('EREDE_MIN_VALUE_FOR_INSTALLMENT')
			|| !Configuration::deleteByName('EREDE_MIN_INSTALLMENT_VALUE', '')
			|| !Configuration::deleteByName('EREDE_SOFT_DESCRIPTOR')
			// || !Log::deleteTable(Db::getInstance(_PS_USE_SQL_SLAVE_), _DB_PREFIX_)
			// || !$this->removeTransactionIdColumnOnOrders()
			){
				return false;
			}
		return true;
	}


	public function getContent()
	{
		$errors = array();
		$success = false;

		$this->context->controller->addJquery();
		$this->context->controller->addCss($this->_path.'views/css/style.css', 'all');
		$this->context->controller->addCss($this->_path.'views/css/lightbox.css', 'all');

		if (Tools::getValue('submiteredemodulo')) {
			$affiliation = Tools::getValue('EREDE_AFFILIATION');
			Configuration::updateValue('EREDE_AFFILIATION', $affiliation);

			$password = Tools::getValue('EREDE_PASSWORD');
			Configuration::updateValue('EREDE_PASSWORD', $password);

			$environment = Tools::getValue('EREDE_ENVIRONMENT');
			Configuration::updateValue('EREDE_ENVIRONMENT', $environment);

			$maxInstallmentNumber = Tools::getValue('EREDE_MAX_INSTALLMENTS_NUMBER');
			Configuration::updateValue('EREDE_MAX_INSTALLMENTS_NUMBER', $maxInstallmentNumber);

			$minValueForInstallment = Tools::getValue('EREDE_MIN_VALUE_FOR_INSTALLMENT');
			Configuration::updateValue('EREDE_MIN_VALUE_FOR_INSTALLMENT', $minValueForInstallment);

			$minInstallmentValue = Tools::getValue('EREDE_MIN_INSTALLMENT_VALUE');
			Configuration::updateValue('EREDE_MIN_INSTALLMENT_VALUE', $minInstallmentValue);

			$softDescriptor = Tools::getValue('EREDE_SOFT_DESCRIPTOR');
			Configuration::updateValue('EREDE_SOFT_DESCRIPTOR', $softDescriptor);

			$automaticCapture = Tools::getValue('EREDE_AUTOMATIC_CAPTURE');
			Configuration::updateValue('EREDE_AUTOMATIC_CAPTURE',$automaticCapture);

			$success = true;
		}

		$this->context->smarty->assign(
		array(
			'affiliation' => htmlentities(Configuration::get('EREDE_AFFILIATION'), ENT_COMPAT, 'UTF-8'),
			'password' => htmlentities(Configuration::get('EREDE_PASSWORD'), ENT_COMPAT, 'UTF-8'),
			'environment' =>  htmlentities(Configuration::get('EREDE_ENVIRONMENT') != "" ? Configuration::get('EREDE_ENVIRONMENT'):'production', ENT_COMPAT, 'UTF-8'),
			'automaticCapture' =>  htmlentities(Configuration::get('EREDE_AUTOMATIC_CAPTURE') != "" ? Configuration::get('EREDE_AUTOMATIC_CAPTURE'):'true', ENT_COMPAT, 'UTF-8'),
			'maxInstallmentNumber' =>  htmlentities(Configuration::get('EREDE_MAX_INSTALLMENTS_NUMBER'), ENT_COMPAT, 'UTF-8'),
			'minValueForInstallment' => htmlentities(Configuration::get('EREDE_MIN_VALUE_FOR_INSTALLMENT'), ENT_COMPAT, 'UTF-8'),
			'softDescriptor' => htmlentities(Configuration::get('EREDE_SOFT_DESCRIPTOR'), ENT_COMPAT, 'UTF-8'),
			'minInstallmentValue' => htmlentities(Configuration::get('EREDE_MIN_INSTALLMENT_VALUE') != "" ? Configuration::get('EREDE_MIN_INSTALLMENT_VALUE'): '5.00', ENT_COMPAT, 'UTF-8'),
			'errors'  => $errors,
			'success' => $success,
			'version' => htmlentities($this->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'this_path_ssl' => (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
			.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__

			)
		);

		return $this->display(__file__, '/views/templates/settings.tpl');
	}

	public function hookPayment($params)
	{

		$this->context->controller->addCss($this->_path.'views/css/payment.css', 'all');
		if (!$this->active)
			return;

		$this->smarty->assign(array(
			'version' => htmlentities($this->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'this_path_ssl' => (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
			.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
		));
		return $this->context->smarty->fetch(__FILE__, 'payment.tpl');
	}

	public function hookPaymentReturn($params)
	{
	    /**
	    * http://sualoja.com.br/confirmacao-de-pedido?id_cart=23&id_module=97&id_order=9&key=4e13415837e16e88eb1b32a19bab8cb9
	    */
		if (!$this->active)
			return;

		global $cookie;
		$id_lang = $cookie->id_lang;

		$state = $params['order']->getCurrentState();

		if ($state == Configuration::get('EREDE_STATUS_0') || $state == Configuration::get('EREDE_STATUS_1'))
		{
			$this->smarty->assign(array(
				'total_to_pay' => Tools::displayPrice($params['total_to_pay'], $params['currencyObj'], false),
				'status' => 'ok',
				'id_order' => $params['order']->id
			));

			$objOrder =  $params['order'];

			if (isset($params['order']->reference) && !empty($params['order']->reference))
				$this->smarty->assign('reference', $params['order']->reference);

			$this->smarty->assign('status_desc', $this->getStatusName($state, $id_lang));
		}else if ($state == Configuration::get('PS_OS_CANCELED')){
			$this->smarty->assign('status', 'canceled');
			$this->smarty->assign('status_desc', $this->getStatusName($state, $id_lang));
		}else
			$this->smarty->assign('status', 'failed');

		$this->context->smarty->fetch(__FILE__, 'payment_return.tpl');
	}

	private function installModuleTab($tabClass = null, $tabName = null)//, $idTabParent = 0)
    {
        $pass = true;
        $tabNameLang = array();

        if (Tab::getIdFromClassName($tabClass))
            return (true);

        foreach (Language::getLanguages() as $language)
            $tabNameLang[$language['id_lang']] = $tabName;

        $tab = new Tab();
        $tab->name = $tabNameLang;
        $tab->class_name = $tabClass;
        $tab->module = $this->name;
        $tab->id_parent = 10;


        $pass = $tab->save();

        return ($pass);
    }

	private function uninstallModuleTab($tabClass = null)//, $idTabParent = 0)
    {
		$tab = new Tab((int)Tab::getIdFromClassName($tabClass));
        $tab->delete();

        return true;
	}

	private function addTransactionIdColumnOnOrders(){
		$tablename = _DB_PREFIX_."orders";
		$sql= "SELECT COUNT( * ) AS count
					FROM INFORMATION_SCHEMA.COLUMNS
					WHERE table_name =  'ps_orders'
					AND table_schema = DATABASE( )
					AND column_name =  'EREDE_TID'";
		$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->ExecuteS($sql);
		if ($result[0]['count'] == 0){
			$sql = "ALTER TABLE $tablename ADD COLUMN EREDE_TID VARCHAR(100) NOT NULL";
			$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($sql);
		}
		return $result;
	}

	private function removeTransactionIdColumnOnOrders(){
		$tablename = _DB_PREFIX_."orders";
		$sql = "ALTER TABLE $tablename DROP COLUMN EREDE_TID";
		$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->execute($sql);
		return $result;
	}

	public function createStates()
	{
		$order_states = array(
			array('#4169E1', $this->l('Aguardando aprovação'), 'rede', '000010000'),
			array('#32CD32', $this->l('Pagamento aceito'), 'payment', '100010010'),
			array('#ec2e15', $this->l('Reembolsado'), 'refund', '100010000'),
			array('#DC143C', $this->l('Cancelado'), 'cancelado', '100010001')
		);

		$languages = Language::getLanguages();

		foreach ($order_states as $key => $value)
		{

			if (! is_null($this->orderStateAvailable(Configuration::get('EREDE_STATUS_'.$key)))){
				continue;
			} else {
				$order_state = new OrderState();
				$order_state->invoice = $value[3][0];
				$order_state->send_email = $value[3][1];
				$order_state->module_name = $this->name;
				$order_state->color = $value[0];
				$order_state->unremovable = $value[3][2];
				$order_state->hidden = $value[3][3];
				$order_state->logable = $value[3][4];
				$order_state->delivery = $value[3][5];
				$order_state->shipped = $value[3][6];
				$order_state->paid = $value[3][7];
				$order_state->deleted = $value[3][8];
				$order_state->name = array();
				$order_state->template = array();

				foreach (Language::getLanguages(false) as $language)
				{
					$order_state->name[(int)$language['id_lang']] = $value[1];
					$order_state->template[$language['id_lang']] = $value[2];

				}

				if (!$order_state->add()){
					return false;
				}

				$file = _PS_ROOT_DIR_.'/img/os/'.(int)$order_state->id.'.gif';
				copy((dirname(__file__).'/views/img/rede_ico.gif'), $file);

				Configuration::updateValue('EREDE_STATUS_'.$key, $order_state->id);
			}
		}
		return true;
	}

	private function deleteStates()
	{
		for ($index = 0; $index <=3; $index++)
		{
			$order_state = new OrderState(Configuration::get('EREDE_STATUS_'.$index));
			if (!$order_state->delete()){
				return false;
			}
		}
		return true;
	}


	public function checkCurrency($cart)
	{
		$currency_order = new Currency($cart->id_currency);
		$currencies_module = $this->getCurrency($cart->id_currency);

		if (is_array($currencies_module))
			foreach ($currencies_module as $currency_module)
				if ($currency_order->id == $currency_module['id_currency'])
					return true;
		return false;
	}

	public static function orderStateAvailable($id_order_state)
	{
		$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow('
			SELECT `id_order_state` AS ok
			FROM `'._DB_PREFIX_.'order_state`
			WHERE `id_order_state` = '.(int)$id_order_state);
		return $result['ok'];
	}

	public static function getStatusName($id_order_state, $id_lang)
	{
		$query = 'SELECT `name` AS name FROM `'
		._DB_PREFIX_.'order_state`  AS os INNER JOIN `'
		._DB_PREFIX_.'order_state_lang` as osl ON os.id_order_state = osl.id_order_state'
		.' WHERE os.`id_order_state` = '.(int)$id_order_state
		.' AND osl.`id_lang` = '.(int)$id_lang;

		$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($query);

		return $result['name'];
	}

	public function getPrestashopVersion()
		{
			if (version_compare(_PS_VERSION_, '1.6.0.1', '>='))
				$version = 6;
			else if (version_compare(_PS_VERSION_, '1.5.0.1', '>='))
				$version = 5;
			else
				$version = 4;

 			// return $version;
            return 7;
		}


	public function addNewOrderHistory($order, $id_order_state, $employee_id){
		$db_instance = Db::getInstance(_PS_USE_SQL_SLAVE_);
		$dbprefix = _DB_PREFIX_;
		$now = new DateTime();
		$now = $now->format('Y-m-d H:i:s');
		$sql = "INSERT INTO ".$dbprefix."order_history (
							id_employee,
							id_order,
							id_order_state,
							date_add
						)
						VALUES(
							'$employee_id',
							'$order',
							'$id_order_state',
							'$now'
						)";
		return $db_instance->execute($sql);
	}

	public function hookPaymentOptions($params){

	    $payments_options = array(

	   );

	    $payment_option = new PaymentOption();
	    $action_text = "eRede";
        //$payment_option->setLogo(Media::getMediaPath(_PS_MODULE_DIR_ . $this->name . '/views/img/logo.png'));
        $payment_option->setCallToActionText($action_text);
        $payment_option->setModuleName("eRede");
        /** http://sualoja.com.br/compra?step=3&fc=module&module=eredemodulo&controller=payment&credit_card=1 */
        $payment_option->setAction($this->context->link->getModuleLink($this->name, 'payment', array('credit_card' => '1'), true));
        $payment_option->setForm($this->generateForm());
        $payment_option->setAdditionalInformation($this->generateInfo());
        //$payment_option->setAdditionalInformation($this->context->smarty->fetch(_PS_MODULE_DIR_ . $this->name . '/views/templates/hook/payment.tpl'));
        $payments_options[] = $payment_option;

	    return $payments_options;

	}

	public function generateInfo(){
	    try {
	        $this->context->controller->addCss($this->_path.'views/css/payment.css', 'all');
    		$this->smarty->assign(
    		    array(
        			'version' => 6,
        			'this_path_ssl' => (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
        			.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
    		    )
    		);
            //return $this->context->smarty->fetch('module:eredemodulo/views/templates/hook/payment.tpl');
            return $this->display(__FILE__, 'views/templates/hook/payment.tpl');


        } catch (Exception $e) {
            echo 'Exceção capturada: ',  $e->getMessage(), "\n";
        }

    }

	public function generateForm(){
	    try {
	        $this->context->controller->addCss($this->_path.'views/css/payment.css', 'all');
    		$this->smarty->assign(
    		    array(
        			'version' => 6,
        			'this_path_ssl' => (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
        			.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
    		    )
    		);
            //return $this->context->smarty->fetch('module:eredemodulo/views/templates/hook/payment.tpl');
            return $this->display(__FILE__, 'module:eredemodulo/views/templates/hook/payment.tpl');

        } catch (Exception $e) {
            echo 'Exceção capturada: ',  $e->getMessage(), "\n";
        }

    }

}
