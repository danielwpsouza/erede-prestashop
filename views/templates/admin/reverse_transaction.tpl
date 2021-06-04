<div id="loading-div-background">
</div>
<div id="popup" class="popup{$versionCss|escape:'htmlall'}">
	<form id="captureTransaction" action="{$link->getAdminLink('erede', array(), true)|escape:'html'}&token={$tokenPage}" name="capture" method="post">
		<div class="light_header">
			<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_card.png">
			<label>{l s='Pedido ' mod='eredemodulo'}{$order_id|escape:'htmlall'}{l s=' de ' mod='eredemodulo'}{$clientName|escape:'htmlall'}</label>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<label class="titleGreyCap">
				{l s='Deseja estornar essa transação?' mod='eredemodulo'}
			</label>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<div class="central_column">
				<div class="light_button">
					<input type="hidden" name="order_id" value="{$order_id}"/>
					<input type="hidden" name="tid" value="{$transactionId}"/>
					<input type="hidden" name="amount" value="{$amountValue}"/>
					<input type="submit" name="submit_reverse" class="buttonOrange" value="{l s='Estornar transação' mod='eredemodulo'}" />
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
