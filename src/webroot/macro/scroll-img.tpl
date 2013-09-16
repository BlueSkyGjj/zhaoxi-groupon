<div id="player"> 
	<ul> 
	{foreach from=$confLinkListGuanggao item=one key=key}
	<li{if $key eq 0} class="on"{/if}>
		<a href="{$one.link}" target="{$one.target}">
			<img alt="{$one.label}" src="{$one.pic}" width="960" height="100" />
		</a>
	</li> 
	{/foreach}
	</ul> 
	<cite class="num"> 
	{foreach from=$confLinkListGuanggao item=one key=key}
	<span{if $key eq 0} class="on"{/if}>{$key + 1}</span>
	{/foreach}
	</cite> 
</div>