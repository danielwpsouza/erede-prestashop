<div class="mp-module">
	<div id="settings">
	<div id="alerts">
		{if $success eq 'true'}
			{if $version eq 6}
			<div class="bootstrap">
				<div class="alert alert-success">
					{l s='Configuração salva com sucesso.' mod='eredemodulo'}
				</div>
			</div>
		{else}
			<div class="conf">
				{l s='Configuração salva com sucesso.' mod='eredemodulo'}
			</div>
			{/if}
		</div>
		{elseif $errors|@count > 0}
			<div class="error">
				{l s='Falha ao salvar as alterações.' mod='eredemodulo'}
			</div>
			{foreach from=$errors item=error}
			<div class="error">
				{$error|escape:'htmlall'}
			</div>
			{/foreach}
		{/if}
	</div>
	<img class="logo" style="width:100px;" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/logo.png">

	<form id="formSetting" method="post">
		<fieldset>
			<legend>
				<img src="../img/admin/contact.gif" />{l s='Configurações' mod='eredemodulo'}
			</legend>
			<div class="line">
				<div class="columnLabel">
					<div class="title">
						<label>{l s='FILIAÇÃO:' mod='eredemodulo'}</label>
					</div>
					<div class="description">
						número de filiação do estabelecimento junto a Rede
					</div>
				</div>
				<div class="columnField marginTop12">
					<input type="text" class="textBoxSmall onlyNumbers" id="filiacao" name="EREDE_AFFILIATION" value="{$affiliation|escape:'htmlall'}" maxlength="9" />
					<span class="errorMsgV6"></span>
				</div>
			</div>
			<br />
			<div class="line">
				<div class="columnLabel">
					<div class="title">
						<label>{l s='SENHA:' mod='eredemodulo'}</label>
					</div>
					<div class="description">
						senha de acesso gerada no portal Rede
					</div>
				</div>
				<div class="columnField">
					<input type="text" class="textBoxLarge preventSpaceKey" id="token" name="EREDE_PASSWORD" value="{$password|escape:'htmlall'}" maxlength="32" />
					<span class="errorMsgV6"></span>
				</div>
			</div>
			<br />
			<div class="line">
				<div class="columnLabel">
					<div class="title">
						<label>{l s='AMBIENTE:' mod='eredemodulo'}</label>
					</div>
					<div class="description">
						define o ambiente de uso
					</div>
				</div>
				<div class="columnField">
					<select name="EREDE_ENVIRONMENT" id="environment" class="boxSelect">
						 <option value="1">{l s='Produção' mod='eredemodulo'}</option>
						 <option value="0">{l s='Teste' mod='eredemodulo'}</option>
					</select>
				</div>
			</div>
			<br />
			<div class="line">
				<div class="columnLabel">
					<div class="title">
						<label>{l s='TIPO DE TRANSAÇÃO:' mod='eredemodulo'}</label>
					</div>
					<div class="description">
						o tipo de transação que será enviado para a Rede
					</div>
				</div>
				<div class="columnField">
					<select name="EREDE_AUTOMATIC_CAPTURE" id="automaticCapture" class="boxSelect">
						 <option value="true">{l s='Com captura automática' mod='eredemodulo'}</option>
						 <option value="false">{l s='Com captura posterior' mod='eredemodulo'}</option>
					</select>
				</div>
			</div>
			<br />
			<div class="line">
				<div class="columnLabel">
					<div class="title">
						<label>{l s='NÚMERO MÁXIMO DE PARCELAS:' mod='eredemodulo'}</label>
					</div>
					<div class="description">
						define até quantas parcelas sua loja disponibilizará no ato do pagamento
					</div>
				</div>
				<div class="columnField">
					<select name="EREDE_MAX_INSTALLMENTS_NUMBER" id="maxInstallmentNumber" class="boxSelect">
						 <option value="">{l s='Selecione' mod='eredemodulo'}</option>
						 <option value="1">{l s='1x' mod='eredemodulo'}</option>
						 <option value="2">{l s='2x' mod='eredemodulo'}</option>
						 <option value="3">{l s='3x' mod='eredemodulo'}</option>
						 <option value="4">{l s='4x' mod='eredemodulo'}</option>
						 <option value="5">{l s='5x' mod='eredemodulo'}</option>
						 <option value="6">{l s='6x' mod='eredemodulo'}</option>
						 <option value="7">{l s='7x' mod='eredemodulo'}</option>
						 <option value="8">{l s='8x' mod='eredemodulo'}</option>
						 <option value="9">{l s='9x' mod='eredemodulo'}</option>
						 <option value="10">{l s='10x' mod='eredemodulo'}</option>
						 <option value="11">{l s='11x' mod='eredemodulo'}</option>
						 <option value="12">{l s='12x' mod='eredemodulo'}</option>
					</select>
					<span class="errorMsgV6"></span>
				</div>
			</div>
			<br />
			<div class="line">
				<div class="columnLabel">
					<div class="title">
						<label>{l s='VALOR MÍNIMO PARA PARCELAMENTO:' mod='eredemodulo'}</label>
					</div>
					<div class="description">
						define um valor mínimo para disponibilizar a função de parcelamento na sua loja
					</div>
				</div>
				<div class="columnField">
					<input type="text" class="textBox monetary" name="EREDE_MIN_VALUE_FOR_INSTALLMENT" value="{$minValueForInstallment|escape:'htmlall'}" />
					<div class="description textGrey">
						Ex.: 20.00
					</div>
				</div>
			</div>
			<br />
			<div class="line">
				<div class="columnLabel">
					<div class="title">
						<label>{l s='VALOR MÍNIMO DA PARCELA:' mod='eredemodulo'}</label>
					</div>
					<div class="description">
						define um valor mínimo específico para cada parcela
					</div>
				</div>
				<div class="columnField">
					<input type="text" class="textBox monetary" name="EREDE_MIN_INSTALLMENT_VALUE" value="{$minInstallmentValue|escape:'htmlall'}" />
					<div class="description textGrey">
						Ex.: 20.00
					</div>
				</div>
			</div>
			<br />
			<div class="line">
				<div class="columnLabel">
					<div class="title">
						<label>{l s='NOME NA FATURA:' mod='eredemodulo'}
						<img style="cursor: help;width:18px;" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_cvv.png" onclick="exibirToolTip();">
						</label>
					</div>
					<div class="description">
					</div>
				</div>
				<div class="columnField">
					<input type="text" class="textBox" name="EREDE_SOFT_DESCRIPTOR" maxlength="13" value="{$softDescriptor|escape:'htmlall'}" />
				</div>
			</div>
		</fieldset>
				<br />
		<center>
			<input type="submit" name="submiteredemodulo" value="{l s='Salvar' mod='eredemodulo'}" onclick="return performClick();" class="button"/>
		</center>
	</form>
</div>

<div id="loading-div-background" style="display:none;">
</div>
<div id="popup" class="popupV6" style="display:none;height:381px;">
		<div class="light_header">
			<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_card.png">
			<label>Identificação da Fatura</label>
			<div class="clear"></div>
		</div>
		<div class="light_line">
      O parâmetro é composto por 22 caracteres. Os 8 primeiros caracteres são para identificar o nome do estabelecimento, que será exibido de forma estática na fatura do portador do cartão. Após os 8 caracteres, a Rede insere um hífen e disponibiliza mais 13 caracteres a serem enviados dinamicamente por transação.<br>
      <br /><b>Exemplo: nomeloja-nomedoproduto </b><br/> <br/>
      Para utilizar essa funcionalidade, acesse o portal da Rede no menu e.Rede > Identificação na fatura ou entre em contato com a Central de atendimento da Rede. Caso o nome não seja cadastrado, o serviço não será habilitado.<br>
      <br/>Após a habilitação do serviço via portal, a funcionalidade será disponibilizada dentro de um prazo de até 24 horas.
		</div>
		<div class="light_line">
			<div class="central_column" style="padding-left:40%;">
				<div class="light_button">
					<a href="#" class="buttonGrey button-back" onclick="fecharTooltip();">{l s='Voltar' mod='eredemodulo'}</a>
				</div>
			</center>
		</div>
  </div>
</div>
<script type="text/javascript">	
	window.onload = function() {
		document.getElementById("environment").value = "{$environment|escape:'javascript'}";
		document.getElementById("automaticCapture").value = "{$automaticCapture|escape:'javascript'}";
		document.getElementById("maxInstallmentNumber").value = "{$maxInstallmentNumber|escape:'javascript'}";
	}

	$("[id$=filiacao]").blur(function () {
		validateAffiliation($(this));
    });
	
	$("[id$=token]").blur(function () {
		validateToken($(this));
    });
	
	$('[id$=maxInstallmentNumber]').change(function () {
        validadeInstallments();
    });
	
	function performClick() {
		if(validateForm()){
			document.forms['formSetting'].submit();
			return true;
		}
		return false;
	}

	function validateForm() {
		var isValid = true;
		isValid = validateAffiliation($("[id$=filiacao]")) && isValid;
		isValid = validateToken($("[id$=token]")) && isValid;
		isValid = validadeInstallments() && isValid;
		return isValid;
	}
	
	function validadeInstallments() {
		var objInstallments = $('[id$=maxInstallmentNumber]')
		var objErrorMsg = objInstallments.parent().find(".errorMsgV6");
	    var strInstallments = objInstallments.val();
	    
	    //verifica se campos estao vazios
	    if (strInstallments == "" ) {
	    	objInstallments.addClass("errorValidate");
			objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
	        return false;
	    } 
	    else{
	    	objErrorMsg.text("");
	    	objInstallments.removeClass("errorValidate");
			return true;
	    }
	    
	    return true;
	}
	
	function validateAffiliation(objField) {
		var objErrorMsg = objField.parent().find(".errorMsgV6");
		var strValue = objField.val();
		
		if(strValue.length > 0){
			objErrorMsg.text("");
			objField.removeClass("errorValidate");
			return true;
		}
		else{
			objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
			objField.addClass("errorValidate");
			return false;
		}
	}
	
	function validateToken(objField) {
		var objErrorMsg = objField.parent().find(".errorMsgV6");
		var strValue = objField.val();
		
		if(strValue.length > 0){
			objErrorMsg.text("");
			objField.removeClass("errorValidate");
			return true;
		}
		else{
			objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
			objField.addClass("errorValidate");
			return false;
		}
	}
		
	function exibirToolTip() {
		$('#popup').show();
		$("#loading-div-background").show();
	}

	function fecharTooltip() {
		$('#popup').hide();
		$("#loading-div-background").hide();
	}

	$(".preventSpaceKey").keypress(function() {
		var intKey = event.which;
		if (intKey == 32){
			return false;
		}
		return true;
	});

	$('.monetary').keypress(function() {
		var intKey = event.which;
		if ((intKey >= 48 && intKey <= 57) || intKey == 46){
			return true;
		}
		return false;
    });

	$('.onlyNumbers').keypress(function() {
		return onlyNumbers(event);
    });

	$('.monetary').change(function() {
        var objRegex = new RegExp("^[0-9\.]*$");
		var objRegexMonet = new RegExp("^[0-9]+\.[0-9]$");
		var strValue = $(this).val();
        // Se houver caracteres inválidos, limpa o campo
        if (!objRegex.test(strValue)) {
            $(this).val("");
        }else{
			var compl = "";
			if(strValue.indexOf('.') < 0)
			{
				compl= ".00";
			}else if(objRegexMonet.test(strValue)){
				compl= "0";
			}
			$(this).val(strValue+compl);
			strValue = $(this).val();
			objRegexMonet = new RegExp("^[0-9]+\.[0-9][0-9]$");
			if (!objRegexMonet.test($(this).val())) {
				$(this).val("");
			}
		}

	});

	function onlyNumbers(event) {
		var intKey = event.which;
		if ((intKey > 47 && intKey < 58 || intKey == 8)) // numbers from 0 to 9
		{
			return true;
		}
		return false;
	}
</script>