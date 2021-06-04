<div id="loading-div-background">
</div>
<div id="popup" class="popup{$versionCss|escape:'htmlall'}">
	<form id="captureTransaction" action="{$link->getAdminLink('erede', array(), true)|escape:'html'}&token={$tokenPage}" name="capture" method="post">
		<div class="light_header">
			<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_card.png">
			<label>{l s='Detalhamento do Log' mod='eredemodulo'}</label>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<div class="light_column">
				<label>Dados do Log</label>
			</div>
			<div class="light_column ">
				<label>
					{l s='Id do Log: ' mod='eredemodulo'}
					{if 'id'|array_key_exists:$log_info}
						{$log_info.id|escape:'htmlall'}
					{/if}
				</label><br />
				<label>
					{l s='Data/Hora: ' mod='eredemodulo'}
					{if 'timestamp'|array_key_exists:$log_info}
						{$log_info.timestamp|escape:'htmlall'}
					{/if}
				</label>
			</div>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<hr>
			<div class="light_column">
				<label>Dados da Compra</label>
			</div>
			<div class="light_column ">
				<label>
					{l s='Número do Pedido: ' mod='eredemodulo'}
					{if 'id_order'|array_key_exists:$log_info}
						{$log_info.id_order|escape:'htmlall'}
					{/if}
				</label><br />
				<label>
					{l s='Total da Compra: ' mod='eredemodulo'}
					{if 'amount'|array_key_exists:$log_info}
						{$log_info.amount|escape:'htmlall'}
					{/if}
				</label><br />
				<label>
					{l s='Número de Parcelas: ' mod='eredemodulo'}
					{if 'installments'|array_key_exists:$log_info}
						{$log_info.installments|escape:'htmlall'}
					{/if}
				</label><br />
				<label>
					{l s='Moeda: ' mod='eredemodulo'}
					{if 'currency'|array_key_exists:$log_info}
						{$log_info.currency|escape:'htmlall'}
					{/if}
				</label>
			</div>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<hr>
			<div class="light_column">
				<label>Transação Rede</label>
			</div>
			<div class="light_column">
				<label>
					{l s='Tid: ' mod='eredemodulo'}
					{if 'tid'|array_key_exists:$log_info}
						{$log_info.tid|escape:'htmlall'}
					{/if}
				</label><br />
				<label>
					{l s='Total da Compra: ' mod='eredemodulo'}
					{if 'amount'|array_key_exists:$log_info}
						{$log_info.amount|escape:'htmlall'}
					{/if}
				</label><br />
				<label>
					{l s='Número de Parcelas: ' mod='eredemodulo'}
					{if 'installments'|array_key_exists:$log_info}
						{$log_info.installments|escape:'htmlall'}
					{/if}
				</label><br />
				<label>
					{l s='Moeda: ' mod='eredemodulo'}
					{if 'currency'|array_key_exists:$log_info}
						{$log_info.currency|escape:'htmlall'}
					{/if}
				</label>
			</div>
			<div class="clear"></div>
		</div>
		<div class="light_line">
			<div class="light_button log_button">
				<a href="#" class="buttonGrey button-back">{l s='Voltar' mod='eredemodulo'}</a>
			</div>
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
