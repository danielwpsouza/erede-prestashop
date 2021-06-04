<div id="loading-div-background">
</div>
<div id="popup" class="popup{$versionCss|escape:'htmlall'}" style="height:600px">
	<form id="captureTransaction" action="{$link->getAdminLink('erede', array(), true)|escape:'html'}&token={$tokenPage}" name="capture" method="post">
		<div class="light_header">
			<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_card.png">
			<label>{l s='Pedido ' mod='eredemodulo'}{$order_id|escape:'htmlall'}{l s=' de ' mod='eredemodulo'}{$clientName|escape:'htmlall'}</label>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<div class="dateColumn">
				<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_calendar_empty.png">
				<div class="labels">
					<label class="columnTitle">{l s='Data' mod='eredemodulo'}</label>
					<label class="columnValue purple">{$orderDate|escape:'htmlall'}</label>
				</div>
			</div>
			<div class="totalColumn">
				<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_money.png">
				<div class="labels">
					<label class="columnTitle">{l s='Total' mod='eredemodulo'}</label>
					<label class="columnValue green">{$orderTotal|escape:'htmlall'}</label>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<label class="titleGreyCap">
				{l s='Transação e.Rede' mod='eredemodulo'}
			</label>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<div class="light_column">
				<div class="order-info1">
					<label>{l s='Cliente: ' mod='eredemodulo'}{$clientName|escape:'htmlall'}</label><br />
					<label>{l s='Telefone: ' mod='eredemodulo'}{$clientContact|escape:'htmlall'}</label><br />
					<label>{l s='CPF: ' mod='eredemodulo'}{$clientDocument|escape:'htmlall'}</label>
				</div>
			</div>
			<span class="separatorV"></span>
			<div class="light_column">
				<div class="order-info2">
					<label>{l s='Tid: ' mod='eredemodulo'}{$transactionId|escape:'htmlall'}</label><br />
          <label>{l s='BIN: ' mod='eredemodulo'}{$cardNumber|escape:'htmlall'}</label>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="separatorH"></div>
		<div class="light_line">
			<div class="central_column">
				<div class="capture-value-labels">
					<label>{l s='Valor da captura: ' mod='eredemodulo'}{$orderTotal|escape:'htmlall'}</label><br />
					<label>{l s='Parcelas: ' mod='eredemodulo'}{$orderInstallments|escape:'htmlall'}</label><br />
					<label>{l s='Status Rede: ' mod='eredemodulo'}{$acquirerStatus|escape:'htmlall'}</label>
				</div>
			</div>
		</div>
		<div class="light_line">
			<div class="central_column">
				<div class="light_button">
					<input type="hidden" name="tid" value="{$transactionId}"/>
					<input type="hidden" name="order_id" value="{$order_id}"/>
					<input type="hidden" name="amount" value="{$amountValue}"/>
					<input type="submit" name="submit_capture" class="buttonOrange" value="{l s='Capturar transação' mod='eredemodulo'}" />
					<a href="#" class="buttonGrey button-back">{l s='Voltar' mod='eredemodulo'}</a>
				</div>
			</center>
		</div>
	</form>
</div>

<script type="text/javascript">
	$(document).ready(function (){
		$("#loading-div-background").show();
		$('#popup').show();

		$('.button-back').click(function(){
			$('#popup').hide();
			$("#loading-div-background").hide();
		})
	});
</script>
