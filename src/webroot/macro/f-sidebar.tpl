	<div id="sidebar"> 
		<div class="side-single">
			<h2>每日签到</h2> 
			<div class="daysign">
			<a href="{$app_name}/daysign.php" id="link-daysign">
				<div class="weekday">
				{$weekday}
				</div> 
			</a> 
			</div>

			<div class="signtip" id="showSigntip">
			今日未签到
			</div> 

			<div class="signinfo-nologin item-auth-nologin">
				您还没有
				<a class="inner-blk" href="{$app_name}/login.htm"><span>登陆</span></a>,要登陆才能签到。 
			</div> 
			<div class="signinfo">
			每日签到可赚取1积分&nbsp;&nbsp;<span class="item-auth-login" id="showSigninfo"></span>
			</div> 
		</div>

      <div class="side-kefu"> 
		<span style="position: relative; left: 150px; top: 62px;">
			<a target="_blank" href="http://wpa.qq.com/msgrd?v=3&amp;uin={$confSite.kefuQq1}&amp;site=qq&amp;menu=yes"><img border="0" src="{$app_name}/image/button-custom-qq.gif" alt="点击这里给我发消息" title="点击这里给我发消息"></a>
		</span>
		<span style="position: relative; left: 67px; top: 100px;">
			<a target="_blank" href="http://wpa.qq.com/msgrd?v=3&amp;uin={$confSite.kefuQq2}&amp;site=qq&amp;menu=yes"><img border="0" src="{$app_name}/image/button-custom-qq.gif" alt="点击这里给我发消息" title="点击这里给我发消息"></a>
		</span>
		<span style="position: relative; left: 150px; top: 102px;">
			<a target="_blank" href="http://wpa.qq.com/msgrd?v=3&amp;uin={$confSite.kefuQq3}&amp;site=qq&amp;menu=yes"><img border="0" src="{$app_name}/image/button-custom-qq.gif" alt="点击这里给我发消息" title="点击这里给我发消息"></a>
		</span>
		<span style="position: relative; left: 67px; top: 138px;">
			<a target="_blank" href="http://wpa.qq.com/msgrd?v=3&amp;uin={$confSite.kefuQq4}&amp;site=qq&amp;menu=yes"><img border="0" src="{$app_name}/image/button-custom-qq.gif" alt="点击这里给我发消息" title="点击这里给我发消息"></a>
		</span>
      </div> 

      <div class="side-guanzhu"> 
      </div> 

      <div class="side-shipin"> 
		<span><a href="{$app_name}/video.htm">点击查看&raquo;&raquo;&raquo;</a></span>
      </div> 

	  <!-- 
      <div class="side-dingyue"> 
      </div> 

      <div class="side-hezuo"> 
      </div> 

      <div class="side-diaocha"> 
		<span><a href="{$app_name}/vote.htm">参与网站调查&raquo;&raquo;&raquo;</a></span>
      </div> 
	  -->

	<!-- 
   <div class="side-box side-commitment"> 
    <a href="/commitment" target="_blank" hidefocus="true"> <img src="http://s0.meituan.net/www/img/side-commitment.png?v=1" width="238" height="118" alt="美团承诺" /> </a> 
   </div> 
   <div class="side-single"> 
    <div class="inner-blk inner-side"> 
     <a href="http://www.meituan.com/mobile" target="_blank" hidefocus="true"> <img src="http://s1.meituan.net/www/img/side-client.png?v=1" width="208" height="112" alt="美团客户端" /> </a> 
    </div> 
    <div class="inner-blk inner-side"> 
     <a href="http://maoyan.meituan.com" target="_blank" hidefocus="true"> <img src="http://s0.meituan.net/www/img/side-movie.jpg?v=1" width="208" height="112" alt="猫眼电影" /> </a> 
    </div> 
    <div class="inner-blk inner-side  last"> 
     <a href="http://jiudian.meituan.com" target="_blank" hidefocus="true"> <img src="http://s1.meituan.net/www/img/side-jiudian.png?v=1" width="208" height="112" alt="美团酒店手机版" /> </a> 
    </div> 
   </div> 
   <div class="side-box side-box--topic"> 
    <h3 class="side-box__title">热门专题</h3> 
    <div class="detail"> 
     <ul data-widget="hovermark" class="mt-hovermark-container"> 
      <li class="topic-item-w mt-hovermark-item"> <a class="topic-item topic-329" href="/topic/xieshiyan/327" target="_blank" title="纪念青春谢恩师 离别盛宴" style="background-image:url(http://p1.meituan.net/topic/__17571220__2368612.jpg)"> <span class="topic-item__title">纪念青春谢恩师 离别盛宴</span> <i class="mt-hovermark-overlay" style="height: 140px; width: 238px; opacity: 0; background-color: rgb(0, 0, 0);"></i></a> </li> 
     </ul> 
    </div> 
   </div> 
 	-->

	<!--
   <div class="side-single"> 
    <div class="inner-blk lottery"> 
     <a href="/lottery/past" target="_blank" hidefocus="true"> <img src="http://s1.meituan.net/www/img/side-lottery.jpg" width="208" height="62" alt="0元抽奖是真的吗？" /> </a> 
     <div id="lottery-list" style="position: relative; height: 72px; overflow: hidden;"> 
      <ul class="lottery-result-list" style="position: absolute; top: -72px;"> 
       <li>呼伦贝尔自驾之旅 <a target="_blank" href="http://www.meituan.com/deal/hlbe0722.html" style="color:red;">火爆进行中</a></li> 
       <li>索尼最新平板电脑 <a target="_blank" href="http://www.meituan.com/deal/XperiaTabletZ.html" style="color:red;">火爆进行中</a></li> 
       <li>HTC One 现货 <a target="_blank" href="http://www.meituan.com/deal/HTCone0724.html" style="color:red;">火爆进行中</a></li> 
      </ul> 
      <ul class="lottery-result-list" style="position: absolute; top: 0px;"> 
       <li>三星GALAXY S4 <a target="_blank" href="http://www.meituan.com/deal/GalaxyS40723.html" style="color:red;">火爆进行中</a></li> 
       <li>香奈儿五号香水 <a target="_blank" href="http://www.meituan.com/deal/chanelN50722.html" style="color:red;">火爆进行中</a></li> 
       <li>苹果 iPad mini <a target="_blank" href="http://www.meituan.com/lottery/result/ipadmini0719">抽奖结果</a></li> 
      </ul> 
     </div> 
    </div> 
   </div> 
   <div class="side-box"> 
    <a href="http://campus.meituan.com" target="_blank" hidefocus="true"> <img src="http://s1.meituan.net/www/img/side-campus.png?v=2" width="238" height="120" alt="校园招聘" /> </a> 
   </div> 
	-->

   <div class="side-single"> 
    <a class="inner-blk side-feedback inner-img-blk" target="_blank" href="{$app_name}/leavemsg.htm"> <span>您的建议让我们做得更好&raquo;</span> </a> 
    <a class="inner-blk side-business inner-img-blk " target="_blank" href="{$app_name}/feedback.htm"> <span class="no-hover">希望在朝夕购组织团购么？</span><br /> <span>请提交团购信息&raquo;</span> </a> 
    <!-- 
    <a class="inner-blk inner-img-blk side-survey last" href="{$app_name}/vote.htm" target="_blank"> <span class="no-hover">您对朝夕购的印象如何?请告诉朝夕购，让我们更好的为您服务！</span><br /> <span>立即参与用户调查&raquo;</span> </a> 
	-->
   </div> 

     </div>
	 <!-- /#sidebar -->