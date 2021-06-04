<?php
// include('/adqr/log.php');
// include('/adqr/eRede.php');

class toolTipController extends ModuleAdminController {

	public function __construct() {
		parent::__construct();

	}

 	public function carregarToolTip() {
    	$this->display_header = false;
		$this->display_footer = false;
		$this->setTemplate('toolTip.tpl');
 	}
}
