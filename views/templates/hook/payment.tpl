{if $version == 6}
<div class="row eredemodulo">
	<div class="col-xs-12">
{/if}
		<p class="payment_module">
			<a class="eredemodulo" href="{$link->getModuleLink('eredemodulo', 'payment')|escape:'html'}" title="{l s='e.Rede' mod='eredemodulo'}">
				<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/logo.png" alt="{l s='e.Rede' mod='eredemodulo'}" height="30"/>
				{l s='Pagar com e.Rede' mod='eredemodulo'}&nbsp;<span>{l s='(cartão de crédito)' mod='eredemodulo'}</span>
			</a>
			{if $version == 6}
			<span class="eredemodulo" />
			{/if}
		</p>
{if $version == 6}
	</div>
</div>
{/if}
