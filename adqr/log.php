<?php
class Log{
  // public $id = '';
  public $cart_id = '';
  public $tid = '';
  public $environment = '';
  public $cardholder_name = '';
  public $amount = '';
  public $capture_amount = '';
  public $document = '';
  public $card_number = '';
  public $brand = '';
  public $expiration_date = '';
  public $installments = '';
  public $currency = '';
  public $status = '';
  public $return_message = '';
  public $payment_method = '';
  public $authorization_number = '';
  public $nsu = '';
  public $acquirerStatus = '';
  public $message = '';

  private $db_instance, $tablename;

  // CRIA A DEPENDENCIA COM A CONEXAO DO DB
  public function __construct($db_instance, $db_prefix){
    $this->db_instance = $db_instance;
    $this->tablename = $db_prefix."log_orders";
  }

  // CRIACAO DA TABELA INICIAL DO LOG
	public static function createTable($db_instance, $db_prefix){
    $tablename = $db_prefix."log_orders";
		$result = $db_instance->Execute(
					"CREATE TABLE IF NOT EXISTS `$tablename` (
            		`id` INT AUTO_INCREMENT PRIMARY KEY,
				    `cart_id` INT NOT NULL,
				    `tid` VARCHAR(100) NULL,
				    `environment` INT NULL,
				    `cardholder_name` VARCHAR(300) NULL,
				    `amount` DECIMAL(10,2) NULL,
				    `capture_amount` DECIMAL(10,2) NULL,
				    `document` VARCHAR(20) NULL,
				    `card_number` VARCHAR(4) NULL,
				    `brand` VARCHAR(100) NULL,
				    `expiration_date` DATETIME NULL,
				    `installments` INT NULL,
				    `currency` VARCHAR(3) NULL,
				    `status` INT NOT NULL,
				    `return_message` VARCHAR(100) NULL,
				    `payment_method` VARCHAR(100) NULL,
				    `authorization_number` VARCHAR(100) NULL,
				    `nsu` VARCHAR(100) NULL,
					`acquirerStatus` VARCHAR(50) NULL,
					`message` VARCHAR(150) NULL,
            		`step` VARCHAR(50) NULL,
					`timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
			)"
		);
    return $result;
	}

  // DELETA TABELA DE LOG
	public static function deleteTable($db_instance, $db_prefix){
    $tablename = $db_prefix."log_orders";
		$result = $db_instance->Execute(
			"DROP TABLE IF EXISTS `$tablename`"
		);
		return $result;
	}

  // RETORNA VALORES SETADOS NA INSTANCIA EM LISTA
  private function get_values(){
    $getter = create_function('$obj', 'return get_object_vars($obj);');
    $arr = $getter($this);
    $values = array_values($arr);
    return $values;
  }

  // RETORNA PROPRIEDADES EM LISTA
  private function get_fields(){
    $getter = create_function('$obj', 'return get_object_vars($obj);');
    $properties = $getter($this);
    $fields = array_keys($properties);
    return $fields;
  }

  // INSERE NOVA LINHA DE LOG DE ACORDO COM AS PROPRIEDADES DO OBJETO
  public function insert(){
  	$fields = $this->get_fields();
    $fields_str = "`".join("`,`",$fields)."`";
    $values = $this->get_values();
    $values_str = '"'.join('","',$values).'"';
    $sql = "INSERT INTO $this->tablename ($fields_str) VALUES ($values_str)";
    
    $result = $this->db_instance->execute($sql);
 
    return $result;
  }

  // RETORNA LINHAS DE LOG DE ACORDO COM O TRANSACTIONID
  public static function get_by_transaction_id($db_instance, $db_prefix, $tid){
    $tablename = $db_prefix."log_orders";
    $sql = "SELECT timestamp,
                  amount,
                  cardholder_name,
                  document,
                  tid,
                  brand,
                  card_number,
                  installments,
                  acquirerStatus
            FROM $tablename
            WHERE tid = '$tid'";
    return $db_instance->ExecuteS($sql);
  }

}
?>
