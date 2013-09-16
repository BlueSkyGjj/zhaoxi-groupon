<!doctype html>
<html>
	<head>
		<title>  </title>
	</head>

	<body>
	<form id="alipaysubmit" name="alipaysubmit" action="{if $confSite.aplipayGatewayUrl}{$confSite.aplipayGatewayUrl}{else}https://mapi.alipay.com/gateway.do?_input_charset=utf-8{/if}" method="get">
	{foreach from=$ll item=one}
	<input type="hidden" name="{$one.name}" value="{$one.value}" />
	{/foreach}
	</form>

	<script language="javascript">
	document.forms['alipaysubmit'].submit();
//	document.getElementById('alipaysubmit').submit();
	</script>
	</body>
</html>