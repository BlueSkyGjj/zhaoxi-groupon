<!doctype html>
<html>
	<head>
		<title> Title </title>
	</head>

	<body>
	{foreach from=$itemList item=one key=key}
	{if ($key + 1) is div by 2}
	{$key}
	{/if}
	{/foreach}
	</body>
</html>