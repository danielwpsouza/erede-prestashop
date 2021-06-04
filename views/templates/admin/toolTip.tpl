<div id="loading-div-background">
</div>
<div id="popup" class="popup{$versionCss|escape:'htmlall'}">
		<div class="light_header">
			<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/ico_card.png">
			<label>Identificação da Fatura</label>
			<div class="clear"></div>
      O parâmetro é composto por 22 caracteres. Os 8 primeiros caracteres são para identificar o nome do estabelecimento, que será exibido de forma estática na fatura do portador do cartão. Após os 8 caracteres, a Rede insere um hífen e disponibiliza mais 13 caracteres a serem enviados dinamicamente por transação.<br>
      <b>Exemplo: nomeloja-nomedoproduto </b><br>
      Para utilizar essa funcionalidade, acesse o portal da Rede no menu e.Rede > Identificação na fatura ou entre em contato com a Central de atendimento da Rede. Caso o nome não seja cadastrado, o serviço não será habilitado.<br>
      Após a habilitação do serviço via portal, a funcionalidade será disponibilizada dentro de um prazo de até 24 horas.
		</div>
		<div class="light_line">
			<div class="central_column">
				<div class="light_button">
					<a href="#" class="buttonGrey button-back">{l s='Voltar' mod='eredemodulo'}</a>
				</div>
			</center>
		</div>
  </div>
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
