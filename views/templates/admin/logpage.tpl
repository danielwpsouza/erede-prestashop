<button type="button" id="orders-rede" href="{$uri|escape:'htmlall'}" name="orders-rede" class="orders-rede" >
<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/arrow-left.png"><br />
<span>{l s='Voltar para Gerenciamento' mod='eredemodulo'}</span>
</button>

﻿<form method="POST" action="index.php" class="form-horizontal clearfix" id="form-order-rede">
<input type="hidden" name="controller" value="eRede">
<input type="hidden" name="token" value="{$tokenPage}">

<div class="tableLogs">
		<div class="panel">
			<div class="panel-heading">
				{l s='Log de Transações e.Rede' mod='eredemodulo'}
			</div>
			<div class="table-center">
				<table class="table order">
					<thead>
						<tr class="nodrag nodrop">
							<th class="fixed-width-xs text-center">
								<span class="title_box">
									{l s='ID' mod='eredemodulo'}
									<a href="#" name='iddesc' onclick="submitForm('id', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='idasc' onclick="submitForm('id', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th class="w60px">
								<span class="title_box">
									{l s='Número do Pedido' mod='eredemodulo'}
									<a href="#" name='id_orderdesc' onclick="submitForm('id_order', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='id_orderasc' onclick="submitForm('id_order', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th >
								<span class="title_box">
									{l s='Referência' mod='eredemodulo'}
									<a href="#" name='referencedesc' onclick="submitForm('reference', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='referenceasc' onclick="submitForm('reference', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th >
								<span class="title_box">
									{l s='Cliente' mod='eredemodulo'}
									<a href="#" name='customersdesc' onclick="submitForm('customers', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='customersasc' onclick="submitForm('customers' , 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th >
								<span class="title_box">
									{l s='Status' mod='eredemodulo'}
									<a href="#" name='statusdesc' onclick="submitForm('status' , 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='statusasc' onclick="submitForm('status', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th >
								<span class="title_box">
									{l s='Ambiente' mod='eredemodulo'}
									<a href="#" name='environmentdesc' onclick="submitForm('environment', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='environmentasc' onclick="submitForm('environment', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th class="w60px">
								<span class="title_box">
									{l s='Etapa' mod='eredemodulo'}
									<a href="#" name='stepdesc' onclick="submitForm('step', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='stepasc' onclick="submitForm('step', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th>
								<span class="title_box">
									{l s='Data de Criação' mod='eredemodulo'}
									<a href="#" name='datedesc' onclick="submitForm('date', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='dateasc' onclick="submitForm('date', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th></th>
						</tr>
						<tr class="nodrag nodrop filter row_hover">
							<th class="text-center">
								<input type="text" class="filter w40px" name="logFilter_id_log" value="{$query_params['logs.id']}">
							</th>
							<th>
								<input type="text" class="filter w60px" name="logFilter_id_order" value="{$query_params['orders.id_order']}">
							</th>
							<th>
								<input type="text" class="filter" name="logFilter_reference" value="{$query_params['orders.reference']}">
							</th>
							<th>
								<input type="text" class="filter" name="logFilter_customer" value="{$query_params['customer']}">
							</th>
							<th>
								<input type="text" class="filter" name="logFilter_status" value="{$query_params['logs.return_message']}">
							</th>
							<th>
								<select name="logFilter_environment" class="filter center" id="logFilter_environment">
									<option value="">--</option>
									<option value="1" {if $query_params['logs.environment'] eq "1"} selected="true" {/if} >Produção</option>
									<option value="0" {if $query_params['logs.environment'] eq "0"} selected="true" {/if} >Teste</option>
								</select>
							</th>
							<th>
								<select class="filter w80px" name="logFilter_step">
									<option value="">--</option>
									<option value='authorize credit' {if $query_params['logs.step'] eq "authorize credit"} selected="true" {/if}>Autorização crédito</option>
									<option value='capture' {if $query_params['logs.step'] eq "capture"} selected="true" {/if}>Captura</option>
									<option value='void' {if $query_params['logs.step'] eq "void"} selected="true" {/if}>Estorno</option>
								</select>
								<!-- <input type="text" class="filter w80px" name="logFilter_etapa" value="{$query_params.step}"> -->
							</th>
							<th class="text-right">
								<div class="date_range row">
									<div class="input-group fixed-width-md center">
										<input type="text" class="filter datepicker date-input form-control w80px" id="local_logFilter_creation_initial" name="local_logFilter_creation_initial" placeholder="From" value="{$query_params['creation_inicial']}">
										<!-- <input type="hidden" id="logFilter_creation_initial" name="logFilter_creation_initial" value=""> -->
										<span class="input-group-addon">
											<i class="icon-calendar"></i>
										</span>
									</div>
									<div class="input-group fixed-width-md center">
										<input type="text" class="filter datepicker date-input form-control w80px" id="local_logFilter_creation_final" name="local_logFilter_creation_final" placeholder="To" value="{$query_params['creation_final']}">
										<!-- <input type="hidden" id="logFilter_creation_final" name="logFilter_creation_final" value=""> -->
										<span class="input-group-addon">
											<i class="icon-calendar"></i>
										</span>
									</div>
								</div>
							</th>
							<th class="actions">
								<center>
                  <input type="hidden" name="page" value="logs">
									<button type="submit" id="log-transaction" name="log-transaction" class="btn btn-default" value="log-transaction" >
										<i class="icon-search"></i> {l s='Pesquisar' mod='eredemodulo'}
									</button>
								</center>
							</th>
						</tr>
					</thead>
					<tbody>
						{foreach key=indexRow item=logRede from=$LogsRede}

							{if ($indexRow mod 2 == 0)}
							<tr class="even">
							{else}
							<tr class="odd">
							{/if}
								<!-- <td class="row-selector text-center">

								</td> -->
								<td class="pointer fixed-width-xs text-center">
									{$logRede.log_id|escape:'htmlall'}
								</td>
								<td class="pointer fixed-width-xs text-center">
									{$logRede.order_id|escape:'htmlall'}
								</td>
								<td class="pointer">
									{$logRede.reference|escape:'htmlall'}
								</td>
								<td class="pointer">
									{$logRede.customer|escape:'htmlall'}
								</td>
								<td class="pointer text-right w80px">
									{$logRede.message|escape:'htmlall'}
								</td>
								<td class="pointer text-right">
									{$logRede.environment|escape:'htmlall':'UTF-8'}
								</td>
								<td class="pointer text-right w80px">
									{$logRede.step|escape:'htmlall':'UTF-8'}
								</td>
								<td class="pointer text-right">
									{$logRede.date_time|escape:'htmlall'}
								</td>
								<td class="text-right">
									<div class="btn-group pull-right">
                    <input type="hidden" name="filter" value="true">
										<button class="view-log" name="log-transaction" data-id_order="{$logRede.log_id}">
											<i class="icon-search-plus"></i>{l s='Visualizar' mod='eredemodulo'}
										</button>
									</div>
								</td>
							</tr>

						{foreachelse}
							<tr class="odd">
								<td colspan="10" class="text-center">
									{l s='Não há transações a serem exibidas' mod='eredemodulo'}
								</td>
							</tr>
						{/foreach}

					</tbody>
				</table>
			</div>
		</div>

</form>
<div class="log-content"></div>
</div>

<script type="text/javascript">

var getLogPage = function(id_order){
  var data = {
    fc:"module",
    module:"eredemodulo",
    controller:"eRede",
    id_lang:1,
    page:'view_log',
    id_order:id_order,
    content_only:1,
    token:"{$tokenPage}"
  }
  $.ajax({
    url:"index.php",
    data:data,
    success:function(html){
      $(".log-content").html(html);
    },
    error:function(xhr){
      console.log(xhr);
      alert(xhr.responseText);
    }
  });
};

function submitForm(sort, sortway){
	var url = 'index.php?controller=eRede&token={$tokenPage}&page=logs';

	if(sort != undefined)
		url += '&sort=' + sort;

	if(sortway != undefined)
		url += '&sortway=' + sortway;

	$('#form-order-rede').attr('action', url).submit();
};

function load(){
	$('.active').removeClass('active');

	var sort = '{$sort}';
	var sortway = '{$sortway}';

	if(sort != '' && sortway != '') {
		var name = sort + sortway.toLowerCase();
		$('a[name=' + name + ']').addClass('active');
	}
	else
		$('a[name=iddesc]').addClass('active');
}

$(document).ready(function(){
	load();

	$('[class*=page-title]').text('e.Rede');

    if ($("table").find(".datepicker").length > 0) {
      $("table").find(".datepicker").datepicker({
        prevText: '',
        nextText: '',
        altFormat: 'dd-mm-yy'
      });
    }
    
    $("#submitFilterButtonorder").click(function(){
    	submitForm();
    });

	$(".view-log").click(function(e){
		e.preventDefault();
		var id_order = $(this).attr('data-id_order');
		getLogPage(id_order);
	});

	$('.orders-rede').click(function(){
		window.location.href=$(this).attr('href')
	});
})

</script>
