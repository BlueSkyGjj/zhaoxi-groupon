{include file="macro/h.tpl"}
<div id="content"> 
   <div class="mainbox box-topic"> 
    <h2>提供团购信息</h2> 
    <form id="feedback-form" class="common-form" method="post" 
		action="feedbackpost.htm"> 
     <div class="field-group"> 
      <label for="feedback-name">您的称呼</label> 
      <input name="name" data-tips="请填写您的称呼" id="feedback-name" class="f-text" value="" /> 
	  <span class="inline-tip" id="signup-tip" style="display: none;"></span>
     </div> 
     <div class="field-group"> 
      <label for="feedback-mobile">您的电话</label> 
      <input name="mobile" data-tips="请填写您的电话" id="feedback-mobile" class="f-text" value="" /> 
     </div> 
     <div class="field-group"> 
      <label for="feedback-contacts">其他联系方式</label> 
      <input name="contacts" id="feedback-contacts" class="f-text" placeholder="邮箱/手机号/QQ号" value="" /> 
     </div> 
     <div class="field-group"> 
      <label for="feedback-addr">详细地址</label> 
      <input name="addr" data-tips="请填写详细地址" id="feedback-addr" class="f-text" value="" /> 
     </div> 
     <div class="field-group"> 
      <label for="feedback-bizname">团购商家名称</label> 
      <input name="bizname" data-tips="请填写团购商家名称" id="feedback-bizname" class="f-text" value="" /> 
     </div> 
     <div class="field-group"> 
      <label class="text" for="feedback-content">团购内容</label>
      <strong class="warn">请按照如下格式填写您的团购内容</strong> 
      <textarea name="content" data-tips="团购内容不能为空" 
		class="feedback-content"
		id="feedback-content" class="f-textarea">商家介绍： 合作店数： 套餐/产品： 是否有营业执照/其它证书： 合作建议： </textarea> 
     </div> 
     <div class="field-group"> 
      <input type="submit" value="提交" class="form-button" name="commit" /> 
     </div> 
    </form> 
   </div> 
  </div> 
  <div id="sidebar"> 
   <div class="side-single"> 
    <div class="inner-blk side-tips side-tips--no-style"> 
     <h3>合作流程</h3> 
     <ol> 
      <li>第1步：商家提交团购信息</li> 
      <li>第2步：资质审核（7个工作日）</li> 
      <li>第3步：电话沟通</li> 
      <li>第4步：上门洽谈</li> 
     </ol> 
    </div> 
   </div> 
  </div>
{include file="macro/f.tpl"}