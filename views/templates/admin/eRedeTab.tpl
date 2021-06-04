
<button type="button" id="log-transaction" href="{$uri|escape:'htmlall'}&page=logs" name="log-transaction" class="log-transaction" >
<img src="{$this_path_ssl|escape:'htmlall'}modules/eredemodulo/views/img/book.png"><br />
<span>{l s='Log de Transações' mod='eredemodulo'}</span>
</button>

<form method="POST" action="{$uri|escape:'htmlall'}" class="form-horizontal clearfix" id="form-order-rede">
<input type="hidden" name="controller" value="eRede">
<input type="hidden" name="token" value="{$tokenPage}">

<div class="tableTransactions">
		<div class="panel">
			<div class="panel-heading">
				{l s='Gerencimento e.Rede' mod='eredemodulo'}
			</div>

			<div class="table-center">
				<table class="table order">
					<thead>
						<tr class="nodrag nodrop">
							<th class="fixed-width-xs text-center">
								<span class="title_box">
									{l s='ID' mod='eredemodulo'}
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
									<a href="#" name='customersasc' onclick="submitForm('customers', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th class=" text-right">
								<span class="title_box">
									{l s='Total' mod='eredemodulo'}
									<a href="#" name='total_paiddesc' onclick="submitForm('total_paid', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='total_paidasc' onclick="submitForm('total_paid', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th >
								<span class="title_box">
									{l s='Status' mod='eredemodulo'}
									<a href="#" name='current_statedesc' onclick="submitForm('current_state', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='current_stateasc' onclick="submitForm('current_state', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th class=" text-right">
								<span class="title_box">
									{l s='Data' mod='eredemodulo'}
									<a href="#" name='date_upddesc' onclick="submitForm('date_upd', 'DESC')">
										<i class="icon-caret-down"></i>
									</a>
									<a href="#" name='date_updasc' onclick="submitForm('date_upd', 'ASC')">
										<i class="icon-caret-up"></i>
									</a>
								</span>
							</th>
							<th></th>
							<th></th>
							<th></th>
						</tr>
						<tr class="nodrag nodrop filter row_hover">
							<th class="text-center">
								<input type="text" class="filter w40px" name="orderFilter_id_order" value="{$filters.id_order}">
							</th>
							<th>
								<input type="text" class="filter" name="orderFilter_reference" value="{$filters.reference}">
							</th>
							<th>
								<input type="text" class="filter" name="orderFilter_customer" value="{$filters.customerName}">
							</th>
							<th class="text-right">
								<input type="text" class="filter" name="orderFilter_total_paid" value="{$filters.total_paid}">
							</th>
							<th>
								{html_options name="orderFilter_order_state" id="orderFilter_order_state" options=$id_order_states selected=$filters.current_state class="filter center"}
							</th>
							<th class="text-right">
								<div class="date_range row">
									<div class="input-group fixed-width-md center">
										<input type="text" class="filter datepicker date-input form-control w80px" id="orderFilter_initial" name="orderFilter_initial" placeholder="From"
										value="{$filters.date_initial}">
										<span class="input-group-addon">
											<i class="icon-calendar"></i>
										</span>
									</div>
									<div class="input-group fixed-width-md center">
										<input type="text" class="filter datepicker date-input form-control w80px" id="orderFilter_final" name="orderFilter_final" placeholder="To" value="{$filters.date_final}">
										<span class="input-group-addon">
											<i class="icon-calendar"></i>
										</span>
									</div>
								</div>
							</th>
							<th colspan="3" class="actions">
								<center>
									<button type="submit" id="submitFilterButtonorder" name="submitFilterButtonorder" value="submit" class="btn btn-default" >
										<i class="icon-search"></i> {l s='Pesquisar' mod='eredemodulo'}
									</button>
								</center>
							</th>
						</tr>
					</thead>
					<tbody>
						{foreach key=indexRow item=ordRede from=$ordersRede}

							{if ($indexRow mod 2 == 0)}
							<tr class="even">
							{else}
							<tr class="odd">
							{/if}

								<td class="pointer fixed-width-xs text-center" onclick="document.location = '?controller=AdminOrders&amp;id_order={$ordRede.order_id|escape:'htmlall'}&amp;vieworder&amp;token={$tokenOrders|escape:'htmlall'}'">
									{$ordRede.order_id|escape:'htmlall'}
								</td>
								<td class="pointer" onclick="document.location = 'index.php?controller=AdminOrders&amp;id_order={$ordRede.order_id|escape:'htmlall'}&amp;vieworder&amp;token={$tokenOrders|escape:'htmlall'}'">
									{$ordRede.reference|escape:'htmlall'}
								</td>
								<td class="pointer" onclick="document.location = 'index.php?controller=AdminOrders&amp;id_order={$ordRede.order_id|escape:'htmlall'}&amp;vieworder&amp;token={$tokenOrders|escape:'htmlall'}'">
									{$ordRede.customer|escape:'htmlall'}
								</td>
								<td class="pointer text-right" onclick="document.location = 'index.php?controller=AdminOrders&amp;id_order={$ordRede.order_id|escape:'htmlall'}&amp;vieworder&amp;token={$tokenOrders|escape:'htmlall'}'">
									{$ordRede.order_total|escape:'htmlall'}
								</td>
								<td class="pointer" onclick="document.location = 'index.php?controller=AdminOrders&amp;id_order={$ordRede.order_id|escape:'htmlall'}&amp;vieworder&amp;token={$tokenOrders|escape:'htmlall'}'">
									<span class="label color_field" style="{$ordRede.order_state_style|escape:'htmlall'}">
										{$ordRede.order_state_desc|escape:'htmlall'}
									</span>
								</td>
								<td class="pointer text-right" onclick="document.location = 'index.php?controller=AdminOrders&amp;id_order={$ordRede.order_id|escape:'htmlall'}&amp;vieworder&amp;token={$tokenOrders|escape:'htmlall'}'">
									{$ordRede.date_time|escape:'htmlall'}
								</td>
								<td class="text-right">
									<div class="btn-group pull-right">
										{if ($ordRede.current_state == Configuration::get('EREDE_STATUS_0') )}
											<a data-id-order="{$ordRede.order_id|escape:'htmlall'}" data-tid='{$ordRede.tid}' data-cart_id='{$ordRede.cart_id}' class="btn btn-default capture-transaction" title="View">
												<i class="icon-search-plus"></i>{l s='Capturar' mod='eredemodulo'}
											</a>
										{/if}
									</div>
								</td>
								<td class="text-right">
									<div class="btn-group pull-right">
										{if ($ordRede.current_state != Configuration::get('EREDE_STATUS_2') )}
											<a data-id-order="{$ordRede.order_id|escape:'htmlall'}" data-tid='{$ordRede.tid}' data-cart_id='{$ordRede.cart_id}' class="btn btn-default query-transaction" title="View" 
												onclick="document.location = 'index.php?controller=eRede&amp;tid={$ordRede.tid|escape:'htmlall'}&amp;cart_id={$ordRede.cart_id|escape:'htmlall'}&amp;page=query&#95;update&amp;vieworder&amp;token={$tokenPage|escape:'htmlall'}'">
												<i class="icon-search-plus"></i>{l s='Atualizar' mod='eredemodulo'}
											</a>
										{/if}
									</div>
								</td>
								<td class="text-right">
									<div class="btn-group pull-right">
										{if ($ordRede.current_state != Configuration::get('EREDE_STATUS_2') )}
											<a data-id-order="{$ordRede.order_id|escape:'htmlall'}" data-tid='{$ordRede.tid}' data-cart_id='{$ordRede.cart_id}' class="btn btn-default reverse-transaction" title="View">
												<i class="icon-search-plus"></i>{l s='Estornar' mod='eredemodulo'}
											</a>
										{/if}
									</div>
								</td>
							</tr>
						{foreachelse}
							<tr class="odd">
								<td colspan="8" class="text-center">
									{l s='Não há pedidos a serem exibidos' mod='eredemodulo'}
								</td>
							</tr>
						{/foreach}

					</tbody>
				</table>
			</div>
		</div>

<div class="transaction-content"></div>
</div>

</form>

<script type="text/javascript">
	function submitForm(sort, sortway){
		var url = 'index.php?controller=eRede&token={$tokenPage}';

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
			$('a[name=id_orderdesc]').addClass('active');
	};

	$(function() {
		$('[class*=page-title]').text('e.Rede');

		load();

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

		var dots=0;
		var getTransactionPage = function(type, tid, cart_id){
			var data = {
				fc:"module",
				module:"eredemodulo",
				controller:"eRede",
				page:type,
				tid:tid,
				cart_id:cart_id,
				token:"{$tokenPage}"
			}
			$.ajax({
				url:"index.php",
				data:data,
				beforeSend:function(){
					var htmlModal = '<div id="loading-div-background"></div>';
					htmlModal+= '<div id="popup" class="popup{$versionCss|escape:"htmlall"}"><div id="wait" style="margin:30% 48%;"></div></div>';
					dots = setInterval( function() {
					    var $wait = $("#wait");
					    if ( $wait.html().length > 3 )
					        $wait.html("");
					    else{
								$wait.append(".");
							}
						}, 400);
					$('.transaction-content').html(htmlModal);
					$("#loading-div-background").show();
					$('#popup').show();
				},
				success:function(html){
					if (type=='reverse') {
						$("#popup").addClass('reverse-transaction-popup');
					}
					else{
						$("#popup").removeClass('reverse-transaction-popup');
					}

					$html = $('<div/>').html(html).children();

					if ($html.find("#content").length > 0) {
						html = $html.find('#content').html();
						$("#popup").html(html);
					}
					else {
						try {
							alert(JSON.parse(html)['erro']);
						}
						catch (e) {
							alert('erro');
						}
						finally {
							$('.transaction-content').html('');
						}
					}
				},
				error:function(xhr){
					alert(xhr.responseText);
					$('.transaction-content').html('');
				},
				complete:function(){
					clearInterval(dots);
				}
			});
		}

		function preventDoubleClick($that){
			$($that).prop("disabled", true);
			setTimeout(function(){
					$($that).prop("disabled", false);
			}, 500);
		}


		$(".capture-transaction").click(function(e){
			e.preventDefault();
			preventDoubleClick(this);
			var tid = $(this).attr('data-tid');
			var cart_id = $(this).attr('data-cart_id');
			getTransactionPage("capture", tid, cart_id);
		});

		$(".reverse-transaction").click(function(e){
			e.preventDefault();
			preventDoubleClick(this);
			var tid = $(this).attr('data-tid');
			var cart_id = $(this).attr('data-cart_id');
			getTransactionPage("reverse", tid, cart_id);
		});

		$('.log-transaction').click(function(){
			window.location.href=$(this).attr('href')
		})

});
</script>
