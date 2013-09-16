<%@page import="com.sina.sae.util.SaeUserInfo"%>
<%@ page language="java"   pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sina App Engine Java</title>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/favicon.ico" />
<link rel="stylesheet" type="text/css" href="css/theme.css" />
<link rel="stylesheet" type="text/css" href="css/style.css" />
 
<!--[if IE]>
<link rel="stylesheet" type="text/css" href="css/ie-sucks.css" />
<![endif]-->
</head>
<body>
	<div id="container">
    	<div id="header">
        	<h2>Sina App Engine Java  -    <%=SaeUserInfo.getAppName() %></h2>
        	
   	 		<div id="topmenu">
            	<ul>
                	<li class="current"><a href="index.jsp">Overview</a></li>
                	<li ><a href="appinfo.jsp">Application</a></li>
                    <li><a href="monitor.jsp">Monitor</a></li>
                	<li><a href="memory.jsp">Memory</a></li>
                    <li><a href="threads.jsp">Threads</a></li>
              </ul>
          	</div>
      </div>
      
        
        <div id="wrapper">
            <div id="content">
       			<div id="rightnow">
                    <h3 class="reallynow">
                        <span>Sina App Engine Java</span>
                        <br />
                    </h3>
				    <p class="youhave">
				    	<strong>Sina App Engine Java</strong> 是一个<strong>安全、稳定、高可用、良好兼容性</strong>的Java Paas平台，你可以轻松将应用部署到上面，而且不需要维护任何服务器。
				    	此外你还可以使用 <strong>Sina App Engine</strong> 提供的各种分布式云服务，包括<strong>数据库、Cache存储、文件存储、定时任务、Fetchurl、Session</strong>等。
                    </p>
			  </div>
              <div id="infowrap">
              	 <div id="infobox" >
                    <h3>Sina App Engine Java Diagram</h3>
                    <p><img src="img/javaoverview.jpg"  width="356" height="275" style="margin-top: 0px;border: 1px solid #e5e5e5;"/></p>            
                  </div>
              	<div id="infobox"  class="margin-left">
              	 	 <h3>Overview</h3>
              	 	  <p class="youhave">
              	 	  	  <strong>Sina App Engine Java</strong> 运行时环境 <strong>JDK6</strong>&nbsp;&nbsp;支持 <strong>J2EE</strong>标准 <br/>
              	 	  	   <strong>多维立体沙箱</strong>和<strong >隔离机制</strong> 保护应用安全  应用<strong>独享Jetty</strong><br>
              	 	  	   <strong>分布式部署</strong>以及<strong>应用漂移</strong> 机制保障应用永不下线<br/>
              	 	  	   <strong>JVM自动回收</strong>和<strong>JVM自动伸缩</strong> 机制最大限度降低用户成本<br/>
              	 	  	   <strong>云服务和扩展服务</strong> 的支持用户开发应用更加简单<br/>
              	 	  	   <strong>日志、监控、统计</strong> 系统的存在使应用管理更加轻松<br/>
              	 	  	   <strong>开放几乎所有权限</strong> 让编码更加随心所欲<br/>
              	 	  	   <strong>SVN</strong>和<strong>Eclipse插件</strong> 的支持使得应用更新更加快速<br/>
              	 	  	   <strong>本地模拟环境</strong> 减小了开发时对环境因素的忧虑<br/>
              	 	  	       支持<strong>绝大部分框架</strong> 甚至不需要做任何特殊定制<br/>
              	 	  	       支持<strong>Socket、Thread、Reflection </strong>等  应用甚至可以<strong>外连数据库</strong>  
              	 	  </p>
              	 </div>
              	 
             	
                   
                  
                  <div id="infobox">
                    <h3>Store Service</h3>
                     	 <table style="font-size: 14px;">
							<tbody>
								<tr>
	                            	<td width="30%" ><strong>MySQL</strong></td>
	                                <td>和使用普通MySQL一样的分布式的RDC</td>
	                            </tr>
								<tr>
	                            	<td ><strong>Memcache</strong></td>
	                                <td>分布式Memcache缓存</td>
	                            </tr>
								<tr>
	                            	<td ><strong>KVDB</strong></td>
	                                <td>大容量的key-value分布式缓存存储</td>
	                            </tr>
								<tr>
	                            	<td ><strong>Storage</strong></td>
	                                <td>分布式文件存储服务 支持FileWrap</td>
	                            </tr>
								<tr>
	                            	<td ><strong>Session</strong></td>
	                                <td>应用分布式Session服务</td>
	                            </tr>
							</tbody>
					</table>
                  </div>
                   <div id="infobox" class="margin-left">
                    <h3>Other Service</h3>
                     	 <table style="font-size: 14px;">
							<tbody>
								<tr>
	                            	<td width="30%" ><strong>FetchURL</strong></td>
	                                <td>分布式网页抓取服务</td>
	                            </tr>
								<tr>
	                            	<td ><strong>Mail</strong></td>
	                                <td>分布式邮件发送服务</td>
	                            </tr>
								<tr>
	                            	<td ><strong>TaskQueue</strong></td>
	                                <td>分布式任务队列服务</td>
	                            </tr>
								<tr>
	                            	<td ><strong>Cron</strong></td>
	                                <td>分布式定时任务服务</td>
	                            </tr>
								<tr>
	                            	<td ><strong>TmpFS</strong></td>
	                                <td>请求内的临时本地IO读写路径服务</td>
	                            </tr>
							</tbody>
					</table>
                  </div>
              </div>
            </div>
            <div id="sidebar">
  				<ul>
                	<li><h3><a href="#" class="house">Links</a></h3>
                        <ul>
                        	<li><a href="http://sae.sina.com.cn/" target="_blank" class="online">Sina App Engine</a></li>
                    		<li><a href="http://sae.sina.com.cn/?m=devcenter&catId=307" target="_blank" class="report">Java Overview</a></li>
                    		<li><a href="http://e.weibo.com/saet" target="_blank" class="weibo">SAE Weibo</a></li>
                        </ul>
                    <br/>
                    </li>
                    <li><h3><a href="#" class="folder_table">Help</a></h3>
          				<ul>
                        	<li><a href="http://sae.sina.com.cn/?m=devcenter" target="_blank" class="folder">Docs Center</a></li>
                        	<li><a href="http://sae.sina.com.cn/?m=devcenter&catId=308" target="_blank" class="shipping">Getting Started</a></li>
                            <li><a href="http://sae4java.sinaapp.com/doc/index.html" class="invoices"  target="_blank" >Services API</a></li>
                            <li><a href="http://cloudbbs.org/" class="group"  target="_blank">Communtiy</a></li>
                        </ul>
                    <br/>
                    </li>
				</ul>       
          </div>
      </div>
       
</div>
</body>
</html>