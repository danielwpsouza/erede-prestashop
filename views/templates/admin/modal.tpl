
<script type="text/javascript">
  $(document).ready(function(){
    var data = {
      fc:"module",
			module:"eredemodulo",
			controller:"eRede",
			page:"{$type_transaction}",
			tid:"{$tid}",
			token:"{$tokenPage}",
      ajax:'true'
    }
    $.ajax({
      url:"index.php",
      data:data,
      success:function(html){
        $("#popup").html(html);
      },
      error:function(xhr){
        alert(xhr.responseText);
      }
    });
  });
</script>
