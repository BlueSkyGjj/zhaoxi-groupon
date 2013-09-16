{include file="macro/h.tpl"}
<div id="content"> 
   <div class="mainbox box-topic"> 
    <h2>意见反馈</h2> 
    <form id="leavemsg-form" class="common-form" method="post" 
		action="leavemsgpost.htm"> 
     <div class="field-group"> 
      <label for="leavemsg-name">您的称呼</label> 
      <input name="name" data-tips="请填写您的称呼" id="leavemsg-name" class="f-text" value="" /> 
	  <span class="inline-tip" id="signup-tip" style="display: none;"></span>
     </div> 
     <div class="field-group"> 
      <label for="leavemsg-mobile">您的电话</label> 
      <input name="mobile" data-tips="请填写您的电话" id="leavemsg-mobile" class="f-text" value="" /> 
     </div> 
     <div class="field-group"> 
      <label class="text" for="leavemsg-content">意见内容</label>
      <textarea name="content" data-tips="意见内容不能为空" 
		class="feedback-content"
		id="leavemsg-content" class="f-textarea"></textarea> 
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
     <h3>意见反馈</h3> 
     <ol> 
      <li>第1步：用户提交意见</li> 
      <li>第2步：工作人员对意见进行分析</li> 
      <li>第3步：电话沟通</li> 
     </ol> 
    </div> 
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