{include file="../macro/h.tpl"}
<div id="content" class="settings-box settings-form-wrapper"> 
   <div class="dashboard"> 
    <ul> 
     <li><a href="{$app_name}/orderlist/all.htm" >团购订单</a></li> 
	 <!-- 
     <li><a href="{$app_name}/orderlist/feebacklist.htm" >我的评价</a></li> 
     <li><a href="{$app_name}/my/growth.htm" >我的成长</a></li> 
	 -->
     <li class="current"><a href="{$app_name}/my/setting.htm" >账户设置</a></li> 
    </ul> 
   </div> 
   <div class="mainbox mine"> 
    <ul class="filter cf"> 
     <li><a href="{$app_name}/my/setting.htm">基本信息</a></li> 
     <li class="current"><a href="{$app_name}/my/settingaddr.htm">收货地址</a></li> 
    </ul> 
    <div class="address-div"> 
     <div class="table-section"> 
      <table id="address-table" cellspacing="0" cellpadding="0"> 
       <tbody>
        <tr> 
         <th width="12%" class="left">收货人</th> 
         <th width="44%">地址/邮编</th> 
         <th width="19%">电话/手机</th> 
         <th width="25%" class="right">操作</th> 
        </tr> 
		{foreach from=$addrList item=one key=key}
        <tr class="table-item{if $key eq 0} first-item{/if}"> 
         <td>{$one.addrName}</td> 
         <td class="info">{$one.prov} {$one.city} {$one.dist} {$one.addr}，{$one.addrCode}</td> 
         <td class="consignee">{$one.mobile}</td> 
         <td class="right"> 
          <ul class="action hidden"> 
           <li> <a href="javascript:void(0);" class="default set-default" attr-id="{$one.id}">设为默认</a> </li> 
           <li> <a href="javascript:void(0);" class="delete del-addr" attr-id="{$one.id}">删除</a> <span class="separator">|</span> </li>
           <li> <a href="javascript:void(0);" class="edit edit-addr" attr-id="{$one.id}">修改</a> </li> 
          </ul> </td> 
        </tr> 
		{/foreach}
       </tbody>
      </table> 
     </div> 
     <div class="prompt table-section"> 
      <table cellspacing="0" cellpadding="0" border="0"> 
       <caption class="add-address"> 
        <a id="link-add-addr" href="javascript:void(0);" class="add text">添加新地址</a> 
       </caption> 
       <tbody> 
        <tr class="edit-form">
         <td>
          <form id="address-form" class="common-form" action="{$app_name}/my/updateaddr.htm" method="POST"> 
		   <input type="hidden" name="id" value="" />
		   <input type="hidden" name="prov" value="" />
		   <input type="hidden" name="city" value="" />
		   <input type="hidden" name="dist" value="" />
           <div id="address-table0" class="address-table"> 
            <div class="field-group"> 
             <label for="sel-prov"><em>*</em> 所在地区：</label> 
				<select class="address-province" id="sel-prov" name="prov_id"> 
					<option value="">--省份--</option> 
					{foreach from=$provLl item=one}
					<option value="{$one.regionId}">{$one.regionName}</option> 
					{/foreach}
				</select> 
				<select class="address-city" id="sel-city" name="city_id"> 
					<option value="">--城市--</option> 
				</select> 
				<select class="address-district" id="sel-dist" name="dist_id"> 
					<option value="">--市区--</option> 
				</select> 
            </div> 
           <div class="field-group field-group--small"> 
			 <label for="address-field-address"><span class="required">*</span>街道地址：</label> 
			 <input type="text" id="address-field-address" maxlength="60" size="60" name="addr" class="f-text address-detail" value="" /> 
			</div> 
			<div class="field-group"> 
			 <label for="address-field-zipcode"><span class="required">*</span>邮政编码：</label> 
			 <input type="text" id="address-field-zipcode" class="f-text address-zipcode" maxlength="20" size="10" name="addr_code" value="" /> 
			</div> 
			<div class="field-group"> 
			 <label for="address-field-name"><span class="required">*</span>收货人姓名：</label> 
			 <input type="text" id="address-field-name" maxlength="15" size="15" name="addr_name" class="f-text address-name" value="" /> 
			</div> 
			<div class="field-group"> 
			 <label for="address-field-phone"><span class="required">*</span>电话号码：</label> 
			 <input id="address-field-phone" 
				class="f-text address-phone item-login-mobile" 
				type="text" maxlength="20" size="15" name="mobile" value="{if $s_user.mobile}{$s_user.mobile}{/if}" /> 
			</div> 
            <div class="field-group comfirm"> 
             <input type="submit" class="form-button" value="保存" id="btn-save" /> 
             <input type="button" class="form-button" value="取消" id="btn-reset" /> 
            </div> 
           </div> 
          </form></td>
        </tr>
       </tbody> 
      </table> 
     </div> 
    </div> 
   </div> 
  </div>
{include file="../macro/my-sidebar.tpl"}
{include file="../macro/f.tpl"}