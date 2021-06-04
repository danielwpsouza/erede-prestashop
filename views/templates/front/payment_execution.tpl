{capture name=path}{l s='Pagamento por e.Rede' mod='eredemodulo'}{/capture}
{if $version == 5}
{include file="$tpl_dir./breadcrumb.tpl"}
{/if}
<h2>{l s='Dados do Pagamento' mod='eredemodulo'}</h2>

{assign var='current_step' value='payment'}
{include file="$tpl_dir./order-steps.tpl"}

{if $nbProducts <= 0}
	<p class="warning">{l s='Seu carrinho está vazio.' mod='eredemodulo'}</p>

{else}
{if $errorAcquirer eq 'true'}
	<div class="warning">
		<label class="title">{l s='Não foi possível realizar a transação' mod='eredemodulo'}</label><br />
		<label class="message">{l s='Por favor, tente utilizar outro cartão de crédito ou entre em contato com a central de atendimento do seu cartão' mod='eredemodulo'}</label>
	</div>
{/if}

<form id="formPayment" action="{$link->getModuleLink('eredemodulo', 'integration', array(), true)|escape:'html'}" method="post">
	<fieldset class="board{$versionCss|escape:'htmlall'}">
		<input type="hidden" id="errorAcquirerCounter" name="errorAcquirerCounter" value="{$errorAcquirerCounter|escape:'htmlall'}">
		<div class="line">
			<div class="columnField">			
				<div class="title">
					<label>{l s='Nome do Titular do Cartão' mod='eredemodulo'}</label>
				</div>
				<div class="field">
					<input type="text" class="textBoxLarge upper alphabetical" id="cardHolderName" name="EREDE_CARD_HOLDER_NAME" value="" maxlength="40" />
					<img class="tick{$versionCss|escape:'htmlall'}" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/tick.png">
					<span class="errorMsg{$versionCss|escape:'htmlall'}"></span>
				</div>
			</div>
		</div>
		<br />
		<div class="line">
			<div class="columnField">
				<div class="title">
					<label>{l s='CPF' mod='eredemodulo'}</label>
				</div>
				<div class="field">
					<input type="text" class="textBoxLarge numberOnly" id="documentCardHolder" name="EREDE_DOCUMENT_CARD_HOLDER" value="" maxlength="11" />
					<img class="tick{$versionCss|escape:'htmlall'}" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/tick.png">
					<span class="errorMsg{$versionCss|escape:'htmlall'}"></span>
				</div>
			</div>
		</div>
		<br />
		<div class="line">
			<div class="columnField">
				<div class="title">
					<label>{l s='Número do Cartão de Crédito' mod='eredemodulo'}</label>
				</div>
				<div class="field">
					<input type="text" class="textBoxLarge numberOnly" id="cardNumber" name="EREDE_CARD_NUMBER" value="" maxlength="16" />
					<img class="tick{$versionCss|escape:'htmlall'}" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/tick.png">
					<span class="errorMsg{$versionCss|escape:'htmlall'}"></span>
				</div>
				
				<div class="cardTypes{$versionCss|escape:'htmlall'}">
					
					<table class="imagens-bandeira">
						<tr>
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="visa" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/visa.png"/>
								</div>
							</td>	
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="mastercard" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/mastercard.png"/>
								</div>
							</td>
							{if Configuration::get('EREDE_AUTOMATIC_CAPTURE') == 'true'}
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="credz" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/credz.png"/>
								</div>
							</td>
							{/if}	
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="jcb" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/jcb.png"/>
								</div>
							</td>	
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="diners" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/diners.png"/>
								</div>
							</td>	
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="hiper" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/hiper.png"/>
								</div>
							</td>	
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="hipercard" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/hipercard.png"/>
								</div>
							</td>	
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="elo" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/elo.png"/>
								</div>
							</td>	
							<td>
								<div class="frame">
									<span class="helper"></span>
									<img id="amex" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cardTypes/amex.png"/>
								</div>
							</td>
							
						</tr>
					</table>
 					<input type="hidden" name="card_type" value="">
 					<span class="errorMsg{$versionCss|escape:'htmlall'}"></span>
 					
				</div>
			</div>
		</div>
		<br />
		<div class="line">
			<div class="columnField">
				<div class="title">
					<label>{l s='Validade' mod='eredemodulo'}</label>
				</div>
				
				<div class="field">
					<select name="EREDE_MONTH_EXPIRATION" id="monthExpiration" class="boxSelectSmall">
						 <option value="">{l s='mês' mod='eredemodulo'}</option>
						 <option value="01">{l s='01' mod='eredemodulo'}</option>
						 <option value="02">{l s='02' mod='eredemodulo'}</option>
						 <option value="03">{l s='03' mod='eredemodulo'}</option>
						 <option value="04">{l s='04' mod='eredemodulo'}</option>
						 <option value="05">{l s='05' mod='eredemodulo'}</option>
						 <option value="06">{l s='06' mod='eredemodulo'}</option>
						 <option value="07">{l s='07' mod='eredemodulo'}</option>
						 <option value="08">{l s='08' mod='eredemodulo'}</option>
						 <option value="09">{l s='09' mod='eredemodulo'}</option>
						 <option value="10">{l s='10' mod='eredemodulo'}</option>
						 <option value="11">{l s='11' mod='eredemodulo'}</option>
						 <option value="12">{l s='12' mod='eredemodulo'}</option>
						 
					</select>
					{html_options name=EREDE_YEAR_EXPIRATION id=yearExpiration options=$yearRange class=boxSelectSmall}
					<span class="errorMsg{$versionCss|escape:'htmlall'}"></span>
				</div>
			</div>
			<div class="columnField">
				<div class="title">
					<label>{l s='Código de Segurança' mod='eredemodulo'}</label>
				</div>
				<div class="field">
					<input type="text" class="textBoxSmall numberOnly" id="cardCVV" name="EREDE_CVV" value="" maxlength="4" />
					<img class="tick{$versionCss|escape:'htmlall'}" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/tick.png">
					<span class="errorMsg{$versionCss|escape:'htmlall'}"></span>
					<span id="linkCVC" class="icoCVV"><img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_cvv.png"></span>
				</div>
			</div>
		</div>
		<br />
		<div class="line">
			<div class="columnField">
				<div class="title">
					<label>{l s='Número de Parcelas' mod='eredemodulo'}</label>
				</div>
				<div class="field">
					{html_options name=EREDE_INSTALLMENTS id=installments options=$installmentsRange class=boxSelect}
					<span class="errorMsg{$versionCss|escape:'htmlall'}"></span>
				</div>
			</div>
		</div>
		<br />
	</fieldset>
		<center>
			<p class="cart_navigation" id="cart_navigation">
				<a href="#" id="continuePayment" class="exclusive_large" onclick="return performClick();">{l s='Concluir Pagamento' mod='eredemodulo'}</a>
			</p>
			<p class="cart_navigation" id="cart_navigation">
				<a href="{$link->getPageLink('order', true, NULL, 'step=3')|escape:'html'}" class="button_large">{l s='Other payment methods' mod='eredemodulo'}</a>
			</p>
		</center>
	<div id="popup" class="popup{$versionCss|escape:'htmlall'}">
		<span id="linkCVC" class="btnClose" href="#"><img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/btn_fechar.gif"></span>
		<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/cvv.jpg">
	</div>
	<div id="loading-div-background">
	  <div id="loading-div" class="ui-corner-all">
	    <img style="height:32px;width:32px;margin:30px;" src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/spinner.gif" alt="Loading.."/>
		<label>{l s='Aguarde' mod='eredemodulo'}</label>
	  </div>
	</div>
</form>
{/if}
<script type="text/javascript">
	$(document).ready(function (){
		//correção breadcumb quebrado
		$('#center_column').removeClass('grid_5').addClass('grid_7');

		$('input[type=text]').each(function () {
            $(this).next(".tick{$versionCss|escape:'htmlall'}").hide();
        });
	});
	
	$('#linkCVC').click(function () {
        $('#popup').show();
    });

	$('.btnClose').click(function () {
        $('#popup').hide();
    });

	$('.alphabetical').keypress(function (event) {
        return validateAlphabetical(event);
    });

	$('.numberOnly').keypress(function (event) {
        return onlyNumbers(event);
    });


	$('[id$=documentCardHolder]').focus(function () {
        $(this).unmask();
        $(this).attr('maxlength', '11');
	});

	$('[id$=cardNumber]').focus(function () {
        $(this).unmask();
        $(this).attr('maxlength', '16');
	});

	/*CALL VALIDATORS INLINE*/
	$("[id$=cardHolderName]").blur(function () {
		validateCardHolderName($(this));
    });

	$("[id$=documentCardHolder]").blur(function () {
		validateCPF($(this));
    });

 	$("[id$=cardNumber]").blur(function () {
 		validateCreditCard($(this));
     });

	$('[id$=monthExpiration]').change(function () {
        validadeCardExpirationDate();
    });

    $('[id$=yearExpiration]').change(function () {
        validadeCardExpirationDate();
    });

	$("[id$=cardCVV]").blur(function () {
		validateCVV($(this));
    });

    $('[id$=installments]').change(function () {
        validadeInstallments($(this));
    });
	/*-----------------------*/

    function ShowProgressAnimation(){
        $("#loading-div-background").show();
    }

	function getCharCode(e) {
		var charCode = null;
		if (window.event)
			charCode = window.event.keyCode;
		else if (e)
			charCode = e.which;

		return charCode;
	}

	function isAllowedCharCode(charCode) {
		if (charCode == null || charCode == 0 || charCode == 8 || charCode == 9 || charCode == 13 || charCode == 27)
			return true;

	    return false;
	}

	function onlyNumbers(event) {
		var intKey = getCharCode(event);
	    if (isAllowedCharCode(intKey ) || ((intKey > 47 && intKey < 58))) // numbers from 0 to 9
	    {
	        return true;
	    }

	    return false;
	}

	function validateAlphabetical(event) {
		var objRegex = new RegExp("^[a-zA-Z ]+$");
		var objCharCode = getCharCode(event);
	    var strKey = String.fromCharCode(objCharCode);

	    if(isAllowedCharCode(objCharCode) || objRegex.test(strKey)) {
	    	return true;
	    }

	    event.preventDefault();
	    return false;
	}

	function validateForm() {
		var isValid = true;		
		isValid = validateCardHolderName($("[id$=cardHolderName]")) && isValid;
		isValid = validadeCardExpirationDate() && isValid;
		isValid = validateCVV($("[id$=cardCVV]")) && isValid;
		isValid = validadeInstallments($('[id$=installments]')) && isValid;
		isValid = validateCreditCard($('[id$=cardNumber]')) && isValid;
		isValid = validateCPF($('[id$=documentCardHolder]')) && isValid;
		return isValid;
	}

	function performClick() {
		if(validateForm()) {
			ShowProgressAnimation();
			document.forms['formPayment'].submit();
			return true;
		}

		return false;
	}

	/*VALIDATION FUNCTIONS*/
	function validateCardHolderName(objField) {
		var isValid = true;
	    var regex = new RegExp("[\\s]");
	    var objErrorMsg = objField.parent().find(".errorMsg{$versionCss|escape:'htmlall'}");
	    var strValue = $.trim(objField.val());

	    //Se campo está preenchido, torna valido
	    if (strValue.length > 0) {
	    	if (regex.test(strValue)) {
	    		objErrorMsg.text("");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), true);
				objField.removeClass("errorValidate");
	        } else {
	            objErrorMsg.text("{l s='Nome e sobrenome obrigatórios' mod='eredemodulo'}");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
				objField.addClass("errorValidate");
	            isValid = false;
	        }
	    } else {
	        objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
			alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
			objField.addClass("errorValidate");
	        isValid = false;
	    }

	    objField.next(".tick{$versionCss|escape:'htmlall'}").show();
		return isValid;
	}

	function validateCreditCard(objField) {
		var isValid = true;
		var bolCardIsValid = false;
		var strCardType = "";
		var objErrorMsg = objField.parent().find(".errorMsg{$versionCss|escape:'htmlall'}");
		
	    objField.validateCreditCard(function(result) {
	        bolCardIsValid = result.valid;
	        strCardType = result.valid ? result.card_type.name : "";
	    });

		showCardType(strCardType, objField.parent().next(".cardTypes{$versionCss|escape:'htmlall'}"));

	    if (objField.val().length <= 0) {
	        objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
			objField.addClass("errorValidate");
			alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
	        isValid = false;
	    } else {
	    	if (bolCardIsValid) {
	            //Se cartao for diners
	            if (strCardType == 'diners') {
	                mask = "9999 999999 9999";
	            } 
	            else {
	                mask = "9999 9999 9999 9999";
	            }

	            objField.mask(mask);
				objErrorMsg.text("");
				objField.removeClass("errorValidate");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), true);
	        } 
	        else {
				objErrorMsg.text("{l s='Cartão inválido' mod='eredemodulo'}");
				objField.addClass("errorValidate");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
	            isValid = false;
	        }
	    }

	    objField.next(".tick{$versionCss|escape:'htmlall'}").show();
		return isValid;
	}

	function validadeCardExpirationDate() {
		var isValid = true;
		var objMonth = $('[id$=monthExpiration]');
		var objYear = $('[id$=yearExpiration]');
	    var objErrorMsg = objMonth.parent().find(".errorMsg{$versionCss|escape:'htmlall'}");
	    var strMonth = objMonth.val();
	    var strYear = objYear.val();
		objMonth.removeClass("errorValidate");
		objYear.removeClass("errorValidate");
		objErrorMsg.text("");

	    //verifica se campos estao vazios
	    if (strMonth == "" && strYear == "") {
	    	objMonth.addClass("errorValidate");
			objYear.addClass("errorValidate");
	        objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
	        isValid = false;
	    } else if (strMonth == "") {
			objMonth.addClass("errorValidate");
	        objErrorMsg.text("{l s='Selecione o mês' mod='eredemodulo'}");
	        isValid = false;
	    } else if (strYear == "") {
			objYear.addClass("errorValidate");
	        objErrorMsg.text("{l s='Selecione o ano' mod='eredemodulo'}");
	        isValid = false;
	    } else {
	        if (!checkCardExpirationDate(parseInt(strMonth, 10), parseInt(strYear, 10))) {
				objErrorMsg.text("{l s='Cartão fora de validade' mod='eredemodulo'}");
	            isValid = false;
	        }
	    }

		return isValid;
	}

	function validadeInstallments(objField) {
		var isValid = true;
	    var objErrorMsg = objField.parent().find(".errorMsg{$versionCss|escape:'htmlall'}");
	    var strValue = objField.val();

	    if (strValue.length > 0) {
			objErrorMsg.text("");
			alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), true);
			objField.removeClass("errorValidate");
	    } else {
	        objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
			alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
			objField.addClass("errorValidate");
	        isValid = false;
	    }

	    objField.next(".tick{$versionCss|escape:'htmlall'}").show();
		return isValid;
	}

	function validateCVV(objField) {
		var objErrorMsg = objField.parent().find(".errorMsg{$versionCss|escape:'htmlall'}");
		var isValid = true;

	    if (objField.val().length > 0) {
	        if (objField.val().length >= 3 && objField.val().length <= 4) {
				objErrorMsg.text("");
				objField.removeClass("errorValidate");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), true);
	        }
	        else {
				objErrorMsg.text("{l s='Código inválido' mod='eredemodulo'}");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
			objField.addClass("errorValidate");
	            isValid = false;
	        }
	    }
	    else {
	    	objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
			alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
			objField.addClass("errorValidate");
	        isValid = false;
	    }

		objField.next(".tick{$versionCss|escape:'htmlall'}").show();
		
		return isValid;
	}

	function validateCPF(objField) {
		var isValid = true;
	    var objErrorMsg = objField.parent().find(".errorMsg{$versionCss|escape:'htmlall'}");
	    var strValue = objField.val();
	    //Se campo está preenchido, torna valido
	    if (strValue.length > 0) {
	        if (isCPFValid(strValue)) {
	            objErrorMsg.text("");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), true);
				objField.removeClass("errorValidate");
				objField.mask("999.999.999-99");
	        } else {
	            objErrorMsg.text("{l s='CPF inválido' mod='eredemodulo'}");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
				objField.addClass("errorValidate");
	            isValid = false;
	        }
	    } else {
	        objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
			alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
			objField.addClass("errorValidate");
	        isValid = false;
	    }

	    objField.next(".tick{$versionCss|escape:'htmlall'}").show();
		return isValid;
	}

	function validateBrand(objField) {
		var objErrorMsg = objField.parent().find(".errorMsg{$versionCss|escape:'htmlall'}");
		
		for (var i = 0; i < objField.length; i++) {
			if(objField[i].checked) {
				$('input[name="card_type"]').val(objField[i].value); 
				objErrorMsg.text("");
				objField.removeClass("errorValidate");
				alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), true);
				return true;
			}
		}

		objErrorMsg.text("{l s='Campo obrigatório' mod='eredemodulo'}");
		alterTickImage(objField.next(".tick{$versionCss|escape:'htmlall'}"), false);
		objField.addClass("errorValidate");

		return false;
	}
				
	function isCPFValid(cpf) {
		var numbers, digits, sum, i, result, equal_digits;
		cpf = cpf.replace(/[\. ,:-]+/g, "");
	    equal_digits = 1;

	    if (cpf.length < 11)
	    	return false;

	    for (i = 0; i < cpf.length - 1; i++) {
	        if (cpf.charAt(i) != cpf.charAt(i + 1)) {
	            equal_digits = 0;
	            break;
	        }
	    }

	    if (!equal_digits) {
	        numbers = cpf.substring(0,9);
	        digits = cpf.substring(9);	        
	        sum = 0;

	        for (i = 10; i > 1; i--)
	        	sum += numbers.charAt(10 - i) * i;

	        result = sum % 11 < 2 ? 0 : 11 - sum % 11;

	        if (result != digits.charAt(0))
	        	return false;
	        
	        numbers = cpf.substring(0,10);
	        sum = 0;
	        
	        for (i = 11; i > 1; i--)
	        	sum += numbers.charAt(11 - i) * i;
	        
	        result = sum % 11 < 2 ? 0 : 11 - sum % 11;
	        
	        if (result != digits.charAt(1))
	        	return false;

	        return true;
	    }

	    else
	        return false;
	}

	function checkCardExpirationDate(intMonth, intYear) {
	    var objDate = new Date();
	    var intCurrYear = objDate.getFullYear();
	    var intCurrMonth = objDate.getMonth() + 1;
	    if (intYear == intCurrYear) {
	        if (intMonth < intCurrMonth) {
	            return false;
	        }
	    }
	    return true;
	}

	function alterTickImage(field, valid) {
		if(valid) {
			field.attr("src","{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/tick.png");
		}
		else {
			field.attr("src", "{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/wrn.png");
		}
	}

	function showCardType(strType, objLocation) {
		$('input[name="card_type"]').val(strType);
	}

	function preventDoubleClick($that) {
		$($that).prop("disabled", true);
		setTimeout(function(){
				$($that).prop("disabled", false);
		}, 500);
	}
</script>