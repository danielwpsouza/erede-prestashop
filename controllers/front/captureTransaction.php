<?php

class ERedeModuloCaptureTransactionModuleFrontController extends ModuleFrontController
{
	/**
	 * @see FrontController::initContent()
	 */
	public function initContent()
	{
		$this->context->controller->addCss($this->module->getPathUri().'views/css/lightbox.css', 'all');

		$this->context->smarty->assign(array(
			'orderDate' => htmlentities('05/07/2016', ENT_COMPAT, 'UTF-8'),
			'orderTotal' => htmlentities('$75.90', ENT_COMPAT, 'UTF-8'),
			'clientName' => htmlentities('John DOE', ENT_COMPAT, 'UTF-8'),
			'clientContact' => htmlentities('(11) 99999-9999', ENT_COMPAT, 'UTF-8'),
			'clientDocument' => htmlentities('123.456.789-00', ENT_COMPAT, 'UTF-8'),
			'transactionId' => htmlentities('21312312335465476868', ENT_COMPAT, 'UTF-8'),
			'cardLabel' => htmlentities('VISA', ENT_COMPAT, 'UTF-8'),
			'cardNumber' => htmlentities('411111********1111', ENT_COMPAT, 'UTF-8'),
			'orderInstallments' => htmlentities('3x', ENT_COMPAT, 'UTF-8'),
			'acquirerStatus' => htmlentities('Autorizada', ENT_COMPAT, 'UTF-8'),
			'versionCss' => htmlentities('V'.$this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'version' => htmlentities($this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'this_path_ssl' => (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
			.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
		));
		$this->setTemplate('payment_execution.tpl');
	}
}
