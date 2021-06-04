<?php
use erede\model\QueryTransactionResponse;
use erede\model\RefundRequest;
use erede\model\TransactionRequest;
use erede\model\RefundResponse;

require_once(dirname(__FILE__).'/../../adqr/log.php');
require_once(dirname(__FILE__).'/../../adqr/Classloader.php');

class eRedeController extends ModuleAdminController {
	private $order_allowed = array(
		'ASC'  => 'ASC',
		'DESC' => 'DESC'
	);

	public function __construct() {
		parent::__construct();
	}

	// DEFINE AS ROTAS DAS PAGINAS DESTE CONTROLLER A PARTIR DO PARAMETRO $page
	public function initContent() {
		$page = Tools::getValue('page');
		$capture = Tools::isSubmit('submit_capture');
		$reverse = Tools::isSubmit('submit_reverse');
		
		if ($capture || $reverse) {
			$tid = Tools::getValue('tid');
			$order_id = Tools::getValue('order_id');
			$type = $capture ? "capture" : "reverse";
			$this->captureProcess($type, $tid, $order_id);
		}
		else{
			switch ($page) {
				case 'capture':
					$tid = Tools::getValue('tid');
					$order_id = Tools::getValue('order_id');
					$this->transactionPage("capture", $tid);
					break;
				case 'reverse':
					$tid = Tools::getValue('tid');
					$order_id = Tools::getValue('order_id');
					$this->transactionPage("reverse", $tid);
					break;
				case 'logs':
					$this->logPage();
					break;
				case 'view_log':
					$id_log = Tools::getValue('id_order');
					$this->showLogPopup($id_log);
					break;
				case 'query_update':
					$tid = Tools::getValue('tid');
					$cart_id = Tools::getValue('cart_id');
					$this->queryUpdate($tid, $cart_id);
					break;
				default:
					$this->defaultPage();
					break;
			}
		}
	}

	// CONSULTA DA TRANSACAO
	private function queryUpdate($tid, $cart_id) {
		$log = new Log(Db::getInstance(_PS_USE_SQL_SLAVE_), _DB_PREFIX_);
		$now = new DateTime();
		$now = $now->format('Ymd');

		$response = new QueryTransactionResponse();
		$order_id = Order::getOrderByCartId($cart_id);
		$history = new OrderHistory();
		$history->id_order = $order_id;
		
		$query = new Query(Configuration::get('EREDE_AFFILIATION'), Configuration::get('EREDE_PASSWORD'), Configuration::get('EREDE_ENVIRONMENT'));
		$response = $query->getTransactionByReference($cart_id);

		if(!$response->getReturnCode()){
			$order = new Order($order_id);
			$id_order_state = null;
			
			// Configuration::get("EREDE_STATUS_0") -> Aguardando aprovação
			if($order->getCurrentState() == Configuration::get("EREDE_STATUS_0") && $response->getAuthorization()->getStatus() == "Approved")
			{
				// Pagamento aceito
				$id_order_state = Configuration::get("EREDE_STATUS_1");
			}
			// Configuration::get("EREDE_STATUS_2") -> Reembolsado
			// $response->data["status"] = 2 -> Cancelado
			// $response->data["status"] = 3 -> Estornado
			elseif($order->getCurrentState() != Configuration::get("EREDE_STATUS_2") && ($response->getAuthorization()->getStatus() == "Canceled"))
			{
				$id_order_state = Configuration::get("EREDE_STATUS_2");
			}

			if($id_order_state != null)
			{
				$orderState = new OrderState($id_order_state);
				$history->changeIdOrderState($orderState->id, $order_id);
				$this->module->addNewOrderHistory($order_id, $orderState->id, $this->context->employee->id);
			}
		}

		$url = $this->context->link->getAdminLink('eRede');
		Tools::redirectAdmin($url);
	}

	// EFETUA O PROCESSO DE CAPTURA OU ESTORNO DE ACORDO COM O $type QUE PODE SER "reverse" ou "capture"
	private function captureProcess($type, $tid, $cart_id) {
		$amount = Tools::getValue('amount');
		$response = null;
		$order_id = Order::getOrderByCartId($cart_id);
		$history = new OrderHistory();
		$history->id_order = $order_id;
		
		$acquirer = new Acquirer(Configuration::get('EREDE_AFFILIATION'), Configuration::get('EREDE_PASSWORD'), Configuration::get('EREDE_ENVIRONMENT'));
		
		if ($type=="reverse") {
			$refundRequest = new RefundRequest();
			$refundRequest->setAmount($amount);
			$response = $acquirer->refund($tid, $refundRequest);
			$id_order_state = Configuration::get("EREDE_STATUS_2");

			$logData = array(
        		"amount" 		 => (float)$amount/100,
        		"cart_id"		 => $cart_id,
        		"tid" 			 => $response->getTid(),
        		"acquirerStatus" => $response->getReturnCode(),
        		"message" 		 =>$response->getReturnMessage(),
        		"nsu"			 => $response->getNsu(),
        		"step" 			 => "void"
        	);
        
	        $this->saveLog($logData);
		}
		else if ($type=="capture") {
			$transactionRequest = new TransactionRequest();
			$transactionRequest->setAmount($amount);
			$response = $acquirer->capture($tid, $transactionRequest);
			$id_order_state = Configuration::get("EREDE_STATUS_1");

			$logData = array(
        		"amount" 		 => (float)$transactionRequest->getAmount()/100,
        		"cart_id" 		 => $response->getReference(),
        		"tid" 			 => $response->getTid(),
        		"acquirerStatus" => $response->getReturnCode(),
        		"return_message" =>$response->getReturnMessage(),
        		"message" 		 =>$response->getReturnMessage(),
        		"nsu" 			 => $response->getNsu(),
        		"step" 			 => "capture",
        	);

        	$this->saveLog($logData);
		}

		//return code 359 e 360 são os códigos de sucesso no reverse(refund). 
		if ($response->getReturnCode() == "0" || $response->getReturnCode() == "359" || $response->getReturnCode() == "360") {
			$orderState = new OrderState($id_order_state);
			$history->changeIdOrderState($orderState->id, $order_id);
			$this->module->addNewOrderHistory($order_id, $orderState->id, $this->context->employee->id);
			$url = $this->context->link->getAdminLink('eRede');
			Tools::redirectAdmin($url);
		}
	}

	// RETORNA A PAGINA DE TRANSACAO DE ACORDO COM O $type SENDO "capture" OU "reverse"
	private function transactionPage($type, $tid) {
		$this->display_header = false;
		$this->display_footer = false;
		
		$log = new Log(Db::getInstance(_PS_USE_SQL_SLAVE_), _DB_PREFIX_);
		$tid = Tools::getValue('tid');
		$cart_id = Tools::getValue('cart_id');
		
		$query = new Query(Configuration::get('EREDE_AFFILIATION'), Configuration::get('EREDE_PASSWORD'), Configuration::get('EREDE_ENVIRONMENT'));

		$responseQuery = $query->getTransactionByReference($cart_id);
		$transaction_info = $this->getTransactionInfo($tid);
		$address_info = $this->getAddressInfo($cart_id);
		$currencyOrder = new CurrencyCore($this->context->currency->id);

		if (!$responseQuery->getReturnCode())
		{
			if($responseQuery->getCapture()){
				$amount = $responseQuery->getCapture()->getAmount();
			}
			else {
				$amount = $responseQuery->getAuthorization()->getAmount();
			}
			
			$d = (new DateTime($responseQuery->getAuthorization()->getDateTime()))->format('d/m/Y');

			if ($type=="capture") {
				$this->setTemplate('capture_transaction.tpl');
			}
			else if($type=="reverse") {
				$this->setTemplate('reverse_transaction.tpl');
			}

			$this->context->smarty->assign(array(
					'order_id' => $cart_id,
					'orderDate' => htmlentities($d, ENT_COMPAT, 'UTF-8'),
					'orderTotal' => htmlentities(Tools::displayPrice((float)$amount/100, $currencyOrder), ENT_COMPAT, 'UTF-8'),
					'amountValue' => htmlentities($amount, ENT_COMPAT, 'UTF-8'),
					'clientName' => $responseQuery->getAuthorization() ? htmlentities($responseQuery->getAuthorization()->getCardHolderName(), ENT_COMPAT, 'UTF-8') : '',
					'clientContact' => htmlentities($address_info['phone'], ENT_COMPAT, 'UTF-8'),
					'clientDocument' => htmlentities($transaction_info['document'], ENT_COMPAT, 'UTF-8'),
					'transactionId' => $responseQuery->getAuthorization() ? htmlentities($responseQuery->getAuthorization()->getTid(), ENT_COMPAT, 'UTF-8') : '',
					'cardNumber' => htmlentities('**** **** **** '.$transaction_info["card_number"], ENT_COMPAT, 'UTF-8'),
					'orderInstallments' => htmlentities($transaction_info["installments"].'x', ENT_COMPAT, 'UTF-8'),
					'acquirerStatus' => $responseQuery->getAuthorization() ? htmlentities($responseQuery->getAuthorization()->getStatus(), ENT_COMPAT, 'UTF-8') : '',
					'tokenPage' => Tools::getAdminToken('eRede'.$this->id.Context::getContext()->employee->id),
					'versionCss' => htmlentities('V'.$this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
					'version' => htmlentities($this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
					'this_path_ssl' => (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
					.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
				));
		}
		else {
			die(json_encode((array("erro" => $responseQuery->getReturnMessage()))));
		}
	}

	// RETORNA A PRIMEIRA LINHA DE LOG (AUTHORIZE CREDIT) DE ACORDO COM O $tid
	private function getTransactionInfo($tid){
		$sql = "
				SELECT
				*
				FROM "._DB_PREFIX_."log_orders
				WHERE tid = '$tid'
				ORDER BY timestamp ASC
				LIMIT 1";
		$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->ExecuteS($sql);
		
		if ($result) {
			return $result[0];
		}
	}

	// RETORNA DADOS DE ENDERECO DO DONO DO CARRINHO
	private function getAddressInfo($cart_id){
		$sql = "SELECT
						address.*
						FROM "._DB_PREFIX_."orders as orders
						LEFT JOIN "._DB_PREFIX_."customer as customers ON customers.id_customer = orders.id_customer
						LEFT JOIN "._DB_PREFIX_."address as address ON customers.id_customer = address.id_customer
						WHERE orders.id_cart = $cart_id";
		$result =Db::getInstance(_PS_USE_SQL_SLAVE_)->ExecuteS($sql);
		if ($result){
			return $result[0];
		}
	}

	// RETORNA PAGINA MODAL DA PRIMEIRA LINHA DE LOG (AUTHORIZE CREDIT) DE ACORDO COM O ID DO PEDIDO
	private function showLogPopup($id_order){
		$this->display_header = false;
		$this->display_footer = false;
		$tablename = _DB_PREFIX_;
		$sql = "SELECT
						log.*,
						orders.id_order,
						currency.iso_code as currency
						FROM $tablename"."log_orders as log
						INNER JOIN ".$tablename."orders as orders on orders.id_cart = log.cart_id
						INNER JOIN ".$tablename."currency as currency on orders.id_currency = orders.id_currency
						WHERE log.id = '$id_order'
						ORDER BY log.timestamp ASC
						LIMIT 1
						";
		$log_info = Db::getInstance(_PS_USE_SQL_SLAVE_)->ExecuteS($sql);
		
		if ($log_info) {
			$log_info = $log_info[0];
		}
		$this->context->smarty->assign(array(
 				'log_info' 		=> $log_info,
				'tokenPage' 	=> Tools::getAdminToken('eRede'.$this->id.Context::getContext()->employee->id),
				'versionCss' 	=> htmlentities('V'.$this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
				'version' 		=> htmlentities($this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
				'this_path_ssl' => (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
				.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
			));

		$this->setTemplate('view_log.tpl');
	}

	// RETORNA LISTA DE LOGS E FILTRA SE PARAMETROS FOREM PASSADOS (ver paramentros em getLogQueryParams)
	private function logPage(){
		global $cookie;
		$this->context->controller->addCss($this->module->getPathUri().'views/css/eRedeTab.css', 'all');
		$this->context->controller->addCss($this->module->getPathUri().'views/css/lightbox.css', 'all');
		$this->show_toolbar = false;
		parent::initContent();

		$query_params = array(
			"logs.id" 			  => Tools::getValue("logFilter_id_log") ?  Tools::getValue("logFilter_id_log") : '',
			"orders.id_order" 	  => Tools::getValue("logFilter_id_order") ? Tools::getValue("logFilter_id_order") : '',
			"customer"			  => Tools::getValue("logFilter_customer") ? Tools::getValue("logFilter_customer") : '',
			"orders.reference" 	  => Tools::getValue("logFilter_reference") ? Tools::getValue("logFilter_reference") : '',
			"logs.return_message" => Tools::getValue("logFilter_status") ? Tools::getValue("logFilter_status") : '',
			"logs.environment" 	  => Tools::getValue("logFilter_environment") !== false ? Tools::getValue("logFilter_environment") : '',
			"logs.step" 		  => Tools::getValue("logFilter_step") ? Tools::getValue("logFilter_step") : '',
			"creation_inicial"	  => Tools::getValue("local_logFilter_creation_initial") ? Tools::getValue("local_logFilter_creation_initial") : '',
			"creation_final"	  => Tools::getValue("local_logFilter_creation_final") ? Tools::getValue("local_logFilter_creation_final") : ''
		);

		$sort = Tools::getValue('sort') ? Tools::getValue('sort') : '';
		$sort_way = Tools::getValue('sortway') ? Tools::getValue('sortway') : '';

		$sql = $this->getLogQueryParams($query_params);
		$LogsRede = $this->getLogRecords($sql, $sort, $sort_way);
		
		$id_order_states = array("" => $this->module->l('--', 'eredemodulo'));

		$this->context->smarty->assign(array(
			'tokenOrders' 		=> Tools::getAdminToken('AdminOrders'.(int)'30'.Context::getContext()->employee->id),
			'id_order_states' 	=> $id_order_states,
			'LogsRede' 			=> $LogsRede,
			'query_params' 		=> $query_params,
			'sort'				=> $sort,
			'sortway' 			=> $sort_way,
			'logPage' 			=> true,
			'uri'	 			=> $this->context->link->getAdminLink('eRede'),
			'versionCss'		=> htmlentities('V'.$this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'version' 			=> htmlentities($this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'tokenPage' 		=> Tools::getAdminToken('eRede'.$this->id.Context::getContext()->employee->id),
			'this_path_ssl' 	=> (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
			.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
		));

		$this->setTemplate('logpage.tpl');
	}

	// RETORNA A PAGINA PADRAO COM A LISTA DE PEDIDO
	private function defaultPage(){
		global $cookie;
		$filters = array();
		$this->context->controller->addCss($this->module->getPathUri().'views/css/eRedeTab.css', 'all');
		$this->context->controller->addCss($this->module->getPathUri().'views/css/lightbox.css', 'all');
		$this->show_toolbar = false;
		parent::initContent();

		$filters['id_order'] = Tools::getValue('orderFilter_id_order');
		$filters['reference'] = Tools::getValue('orderFilter_reference');
		$filters['customerName'] = Tools::getValue('orderFilter_customer');
		$filters['total_paid'] = Tools::getValue('orderFilter_total_paid');
		$filters['current_state'] = Tools::getValue('orderFilter_order_state');
		$filters['date_initial'] = Tools::getValue('orderFilter_initial');
		$filters['date_final'] = Tools::getValue('orderFilter_final');

		$sort = Tools::getValue('sort') ? Tools::getValue('sort') : '';
		$sort_way = Tools::getValue('sortway') ? Tools::getValue('sortway') : '';

		$ordersRede = $this->getOrdersRede($filters, $sort, $sort_way);
		$id_order_states = array("" => $this->module->l('--', 'eredemodulo'));
		$id_order_states = $this->getOrderStates($id_order_states);

		$this->context->smarty->assign(array(
			'cardHolderName' 	=> '',
			'tokenOrders' 		=> Tools::getAdminToken('AdminOrders'.(int)'30'.Context::getContext()->employee->id),
			'id_order_states' 	=> $id_order_states,
			'ordersRede' 		=> $ordersRede,
			'sort'				=> $sort,
			'sortway'			=> $sort_way,
			'filters'			=> $filters,
			'logPage' 			=> false,
			'uri' 				=>  $this->context->link->getAdminLink('eRede'),
			'versionCss' 		=> htmlentities('V'.$this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'version'	 		=> htmlentities($this->module->getPrestashopVersion(), ENT_COMPAT, 'UTF-8'),
			'tokenPage' 		=> Tools::getAdminToken('eRede'.$this->id.Context::getContext()->employee->id),
			'this_path_ssl' 	=> (Configuration::get('PS_SSL_ENABLED') ? 'https://' : 'http://')
			.htmlspecialchars($_SERVER['HTTP_HOST'], ENT_COMPAT, 'UTF-8').__PS_BASE_URI__
		));

		$this->setTemplate('eRedeTab.tpl');
	}

	// RETORNA LISTA DE POSSIVEIS STATUS DE PEDIDOS
	private function getOrderStates($id_order_states){
		global $cookie;
		$id_lang = $cookie->id_lang;

		$query = '
			SELECT
				state.`id_order_state`,
				stateDesc.`name`
			FROM `'._DB_PREFIX_.'order_state` as state
			JOIN `'._DB_PREFIX_.'order_state_lang` as stateDesc on stateDesc.`id_lang` = '.$id_lang.'
			and stateDesc.`id_order_state` = state.`id_order_state`
			WHERE state.module_name = "eredemodulo"';

		$result = Db::getInstance()->ExecuteS($query);
		foreach ($result as $key => $value) {
			$id_order_states[$value['id_order_state']] = $value['name'];
		}
		return $id_order_states;
	}

	// REALIZA CONSULTA DE PEDIDOS DE ACORDO COM OS FILTROS
	private function getOrdersRede($filters, $sort, $sort_way){
		$sort_fields_map = array(
			'id_order' 		=> 'orders.id_order',
			'reference' 	=> 'orders.reference',
			'customers' 	=> 'customers.firstname',
			'total_paid' 	=> 'total_paid',
			'current_state' => 'stateDesc.name',
			'date_upd' 		=> 'date_upd'
		);

		global $cookie;
		$id_lang = $cookie->id_lang;
		$query = '
			SELECT
				`id_order`,
				`reference`,
				`firstname`,
				`lastname`,
				`id_cart`,
				`id_currency`,
				`total_paid`,
				orders.`current_state`,
				stateDesc.`name`,
				`color`,
				orders.`date_upd`,
				orders.`EREDE_TID`,
				orders.`id_cart`
		FROM `'._DB_PREFIX_.'orders` as orders
		JOIN `'._DB_PREFIX_.'customer` as customers on customers.`id_customer` = orders.`id_customer`
		JOIN `'._DB_PREFIX_.'order_state` as state on state.`id_order_state` = orders.`current_state`
		JOIN `'._DB_PREFIX_.'order_state_lang` as stateDesc on stateDesc.`id_lang` = '.$id_lang.'  and stateDesc.`id_order_state` = state.`id_order_state`
		WHERE `payment` = "e.Rede"';

		if (isset($filters['id_order']) && $filters['id_order']) {
			$id_order = $filters['id_order'];
			$query .= ' and `id_order` = "'.$id_order.'"';
		}
		
		if (isset($filters['reference']) && $filters['reference']) {
			$reference = $filters['reference'];
			$query .= ' and `reference` = "'.$reference. '"';
		}

		if (isset($filters['customerName']) && $filters['customerName']) {
			$customer = $filters['customerName'];
			$query .= " AND (customers.firstname like '%$customer%' OR customers.lastname like '%$customer%') ";
		}

		if (isset($filters['total_paid']) && $filters['total_paid']) {
			$total = preg_replace('/[^0-9\,]/', '', $filters['total_paid']);
			$total = str_replace(',', '.', $total);
			$query .= ' and `total_paid` = CAST('.$total.' AS DECIMAL(20, 6))';
		}

		if (isset($filters['current_state']) && $filters['current_state']) {
			$query .= ' and orders.`current_state` = '.$filters['current_state'];
		}

		if (isset($filters['date_initial']) && $filters['date_initial']) {
			$dateInitial = date_create_from_format('d/m/Y',$filters['date_initial']);
			$dateInitial = $dateInitial->format('Y-m-d');
			$query .= ' and  cast(orders.`date_upd` AS Date ) >= "'.$dateInitial.'"';
		}

		if (isset($filters['date_final']) && $filters['date_final']) {
			$dateFinal = date_create_from_format('d/m/Y',$filters['date_final']);
			$dateFinal = $dateFinal->format('Y-m-d');
			$query .= ' and  cast(orders.`date_upd` AS Date ) <= "'.$dateFinal.'"';
		}

		$query .= empty($sort) || !array_key_exists($sort, $sort_fields_map) 
				? ' ORDER BY id_order ' 
				: ' ORDER BY ' . $sort_fields_map[$sort] . ' ';

		$query .= empty($sort_way) || !array_key_exists($sort_way, $this->order_allowed) 
				? 'DESC' 
				: $sort_way;				

		$ordersRede = array();
		$result = Db::getInstance()->ExecuteS($query);
		$indexRow = 0;
		foreach ($result as $key => $value) {
			$currencyOrder = new CurrencyCore($value['id_currency']);
			$customerName = substr($value['firstname'], 0, 1).'. '.$value['lastname'];
			$ordersRede[$indexRow] = array(
				'order_id' 			=> $value['id_order'],
				'reference'			=> $value['reference'],
				'customer'			=> $customerName,
				'order_total'		=> Tools::displayPrice($value['total_paid'], $currencyOrder),
				'order_state_desc' 	=> $value['name'],
				'order_state_style' => 'background-color:'.$value['color'],
				'date_time' 		=> $value['date_upd'],
				'tid'				=> $value['EREDE_TID'],
				'cart_id' 			=> $value['id_cart'],
				'current_state' 	=>  $value['current_state']
			);
			$indexRow++;
		}
		return $ordersRede;
	}

	// DEFINE E RETORNA A SQL STRING DE FILTROS PARA A TELA DE LOG
	private function getLogQueryParams($params_eq){
		$sql ="";
		
		foreach ($params_eq as $field => $value) {
			if ($value != '') {
				$value = str_replace("'", "\'", $value);

				if ($field === 'customer')
					$sql .= " AND (customers.firstname like '%$value%' OR customers.lastname like '%$value%') ";
				else if ($field === 'creation_inicial') {
					$initial_date = $value;
					$initial_date = date_create_from_format('d/m/Y',$initial_date);
					$initial_date_str = $initial_date->format('Y-m-d');
					$sql .= " AND logs.timestamp >= '$initial_date_str'";
				}
				else if ($field === 'creation_final') {
					$final_date = $value;
					$final_date = date_create_from_format('d/m/Y',$final_date);
					$final_date->add(new DateInterval('P1D'));
					$final_date = $final_date->format('Y-m-d');
					$sql .= " AND logs.timestamp <= date('$final_date')";
				}
				else
					$sql .= " AND $field = '$value'";
			}
		}

		return $sql;
	}

	private function getStatement($filtersSql, $sort, $sort_way){
		$sort_fields_map = array(
			'id' 			=> 'logs.id',
			'id_order' 		=> 'orders.id_order',
			'reference' 	=> 'orders.reference',
			'customers' 	=> 'customers.firstname',
			'status' 		=> 'logs.message',
			'environment' 	=> 'desc_environment',
			'step' 			=> 'logs.step',
			'date' 			=> 'logs.timestamp'
		);

		$sql = '
			SELECT
			`id`,
			orders.`id_order`,
			orders.`reference`,
			customers.`firstname`,
			customers.`lastname`,
			`acquirerStatus`,
			`environment`,
			CASE logs.environment 
		    WHEN 0 THEN \'TESTE\'
		    WHEN 1 THEN \'PRODUÇÃO\'
		    ELSE \'\' END AS \'desc_environment\',
			`timestamp`,
			logs.`step`,
			logs.`message`
			FROM `'._DB_PREFIX_.'log_orders` as logs
			LEFT JOIN `'._DB_PREFIX_.'orders` as orders on orders.`id_cart` = logs.`cart_id`
			LEFT JOIN `'._DB_PREFIX_.'customer` as customers on customers.`id_customer` = orders.`id_customer`';

		$sql .= empty($filtersSql) ? ' WHERE 1 ' : 'WHERE 1 ' . $filtersSql;

		$sql .= empty($sort) || !array_key_exists($sort, $sort_fields_map) 
				? ' ORDER BY id ' 
				: ' ORDER BY ' . $sort_fields_map[$sort] . ' ';

		$sql .= empty($sort_way) || !array_key_exists($sort_way, $this->order_allowed) 
				? 'DESC' 
				: $sort_way;

		return @$sql;
	}
	
	// CONSULTA LINHAS DO LOG
	private function getLogRecords($filtersSql, $sort, $sort_way){
		$logs = array();

		$sql = $this->getStatement($filtersSql, $sort, $sort_way);

		$result = Db::getInstance()->ExecuteS($sql);

		$indexRow = 0;
		foreach ($result as $key => $value) {
			$customerName = substr($value['firstname'], 0, 1).'. '.$value['lastname'];
			$value['timestamp'] = new DateTime($value['timestamp']);
			$value['timestamp'] = $value['timestamp']->format('d/m/Y H:i:s');
			$steps = array(
				"authorize credit" => "Autorização crédito",
				"capture" => "Captura",
				"void" => "Estorno"
			);
			$logs[$indexRow] = array(
				'log_id' 		 => $value['id'],
				'order_id' 		 => $value['id_order'],
				'reference' 	 => $value['reference'],
				'customer' 		 => $customerName,
				'acquirerStatus' => $value['acquirerStatus'],
				'environment' 	 => $value['environment'] == 0 ? "Teste" : "Produção",
				'date_time' 	 => $value['timestamp'],
				'step' 			 => $steps[$value['step']],
				'message' 		 => $value['message']
			);
			$indexRow++;
		}

		return $logs;
	}

	private function saveLog($arr) {
		$log = new Log(Db::getInstance(_PS_USE_SQL_SLAVE_), _DB_PREFIX_);

    	foreach($arr as $key => $value) {
    		$log->{$key} = $value;
    	}

    	$log->insert();
    }
}
?>
