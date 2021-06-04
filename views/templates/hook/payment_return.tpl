
{if $status == 'ok'}
<p>
	<h4><strong>{l s='Sua compra foi finalizada com sucesso. Obrigado por comprar conosco!' mod='eredemodulo'}</strong></h4>
</p>
<p>
	<br />
	<b>{l s='Total da sua compra: ' mod='eredemodulo'}</b> <span class="price">{$total_to_pay}</span>
	<br />
	<b>{l s='Referência da sua compra: ' mod='eredemodulo'}</b> {$reference}
	<br />
	<b>{l s='Status: ' mod='eredemodulo'}</b> {$status_desc}
	<br />
	<br />
	<strong>{l s='Quaisquer dúvidas, por favor entre em contato conosco através do nosso atendimento.' mod='eredemodulo'}</strong>
</p>
{else}
<p>
	<h3>{l s='Um erro ocorreu: ' mod='eredemodulo'}</h3>
</p>
<p>
	{l s='Seu pedido foi cancelado. Por favor, efetue um novo pedido. Se necessário você também poderá selecionar uma nova forma de pagamento.' mod='eredemodulo'}
	<br />
	<br />{l s='Em caso de dúvida favor utilizar o formulário de contato.' mod='eredemodulo'}
	<br />
</p>
{/if}
