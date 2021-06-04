<div id="popup" class="popup{$versionCss|escape:'htmlall'}">
	<form id="captureTransaction" action="{$link->getModuleLink('eredemodulo', 'integrationBackend', array(), true)|escape:'html'}" method="post">
		<div class="light_header">
			<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_card.png">
			<label>{l s='Pedido ' mod='eredemodulo'}{$orderReference|escape:'htmlall'}{l s=' de ' mod='eredemodulo'}{$clientName|escape:'htmlall'}</label>
		</div>
		<div class="light_line">
			<div class="dateColumn">
				<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_calendar_empty.png">
				<label class="columnTitle">{l s='Data' mod='eredemodulo'}</label>
				<label class="columnValue purple">{$orderDate|escape:'htmlall'}</label>
			</div>
			<div class="totalColumn">
				<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_money.png">
				<label class="columnTitle">{l s='Total' mod='eredemodulo'}</label>
				<label class="columnValue green">{$orderTotal|escape:'htmlall'}</label>
			</div>
		</div>
		<div class="light_line">
			<label class="titleGreyCap">
				{l s='Transação e.Rede' mod='eredemodulo'}
			</label>
		</div>
		<div class="light_line">
			<div class="light_column">
				<label>{l s='Cliente: ' mod='eredemodulo'}{$clientName|escape:'htmlall'}</label><br />
				<label>{l s='Telefone: ' mod='eredemodulo'}{$clientContact|escape:'htmlall'}</label><br />
				<label>{l s='CPF: ' mod='eredemodulo'}{$clientDocument|escape:'htmlall'}</label>
			</div>
			<span class="separatorV"></span>
			<div class="light_column">
				<label>{l s='Tid: ' mod='eredemodulo'}{$transactionId|escape:'htmlall'}</label><br />
				<label>{l s='Bandeira: ' mod='eredemodulo'}{$cardLabel|escape:'htmlall'}</label><br />
				<label>{l s='BIN: ' mod='eredemodulo'}{$cardNumber|escape:'htmlall'}</label>
			</div>
		</div>
		<div class="separatorH"></div>
		<div class="light_line">
			<div class="central_column">
				<label>{l s='Valor da captura: ' mod='eredemodulo'}{$orderTotal|escape:'htmlall'}</label><br />
				<label>{l s='Parcelas: ' mod='eredemodulo'}{$orderInstallments|escape:'htmlall'}</label><br />
				<label>{l s='Status Rede: ' mod='eredemodulo'}{$acquirerStatus|escape:'htmlall'}</label>
			</div>
		</div>
		<div class="light_line">
			<center>
				<div class="light_button">
					<input type="submit" class="buttonOrange" value="{l s='Capturar transação' mod='eredemodulo'}" />
					<a href="#" class="buttonGrey">{l s='Voltar' mod='eredemodulo'}</a>
				</div>
			</center>
		</div>
	</form>
</div>
<div id="loading-div-background">
</div>

<script type="text/javascript">
	$(document).ready(function (){
		$("#loading-div-background").show();
		$('#popup').show();
	});
</script>