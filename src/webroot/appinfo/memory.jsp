<%@page import="java.lang.management.GarbageCollectorMXBean"%>
<%@page import="java.lang.management.MemoryUsage"%>
<%@page import="java.lang.management.MemoryPoolMXBean"%>
<%@page import="java.lang.management.MemoryType"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.lang.management.MemoryManagerMXBean"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.management.RuntimeMXBean"%>
<%@page import="java.lang.management.MemoryMXBean"%>
<%@page import="java.lang.management.ManagementFactory"%>
<%@page import="java.util.Date"%>
<%@page import="com.sina.sae.util.SaeUserInfo"%>
<%@ page language="java"   pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%
 	MemoryMXBean memoryMXBean =  ManagementFactory.getMemoryMXBean();
 	RuntimeMXBean rMXBean = ManagementFactory.getRuntimeMXBean();	
 	String [] node = rMXBean.getName().split("@");//节点名称
 	String nodename = node[node.length-1];
 	String currentNode = nodename+request.getLocalPort();
 	List<MemoryPoolMXBean> li = ManagementFactory.getMemoryPoolMXBeans();
 	MemoryUsage tenured=null,eden=null,surivor=null,perm=null,code=null;
 	for(MemoryPoolMXBean mpm:li){
 		String poolName = mpm.getName();
 		if(poolName.endsWith("Survivor Space")){
 			surivor = mpm.getUsage();
 		}else if(poolName.endsWith("Tenured Gen")||poolName.endsWith("Old Gen")){
 			tenured = mpm.getUsage();
 		}else if(poolName.endsWith("Eden Space")){
 			eden = mpm.getUsage();
 		}else if(poolName.endsWith("Perm Gen")){
 			perm = mpm.getUsage();
 		}else if(poolName.endsWith("Code Cache")){
 			code = mpm.getUsage();
 		}
 	}
 	//年轻带整体使用情况
 	long edenMax = eden.getMax();
 	long surivorMax = surivor.getMax();
 	long tenuredMax = tenured.getMax();
 	long youngMax = edenMax+surivorMax+tenuredMax;
 	long edenPer = 100*edenMax/youngMax;
 	long surivorPer = 100*surivorMax/youngMax;
 	long tenuredPer = 100-edenPer - surivorPer;
 	
 	//持久带整体使用情况
 	long codeMax = code.getMax();
 	long permMax = perm.getMax();
 	long oldMax = permMax + codeMax;
 	long permPer = 100*permMax/oldMax;
 	long codePer = 100- permPer;
 	 
 	//GC情况
	List<GarbageCollectorMXBean> aGCMXBeans = ManagementFactory.getGarbageCollectorMXBeans();
	long gccount = 0,gctime=0;
	for(GarbageCollectorMXBean aGCMXBean:aGCMXBeans){
		gccount = gccount + aGCMXBean.getCollectionCount();
		gctime = gctime + aGCMXBean.getCollectionTime() ;
	}
 	
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sina App Engine Java</title>
<link rel="shortcut icon" href="<%=request.getContextPath() %>/favicon.ico" />
<link rel="stylesheet" type="text/css" href="css/theme.css" />
<link rel="stylesheet" type="text/css" href="css/style.css" />
<script type="text/javascript" src="js/jquery-1.7.1.js"></script>
<script src="js/highstock.js"></script>
<script src="js/exporting.js"></script>
<script src="js/chartsutil.js"></script>
<!--[if IE]>
<link rel="stylesheet" type="text/css" href="css/ie-sucks.css" />
<![endif]-->
 
 	
	<script type="text/javascript">
	var young,old,codecache,permgen,oTimer;
	$(function() {
		Highcharts.setOptions({global : {useUTC : false,title : null,exporting: {enabled: false}}});
		new HighchartsPieWrap("heapmemory","Heap Percent",[['Eden', <%=edenPer%>],['Tenured', <%=tenuredPer%>],['Surivor', <%=surivorPer%>]]);
		new HighchartsPieWrap("nonheapmemory","HeapMemory Percent",[['Perm Gen', <%=permPer%>],['Code Cache', <%=codePer%>]]);
		
		young = new StockChartWrap("young",{load : function() {ajaxData();}},"Eden Used","Surivor Used");
		old = new StockChartWrap("old",null,"tenuredMax","tenuredUsed");
		codecache = new StockChartWrap("codecache",null,"CodeCache Max","CodeCache Used");
		permgen = new StockChartWrap("permgen",null,"PermGen Max","PermGen Used");
	});
	
	function ajaxData() {
		var x = (new Date()).getTime(); // current time
		$.ajax({type:"post", url:"ajax.jsp", data:{type:"memory",node:"<%=currentNode%>"},success:function(data,textStatus){
				if(textStatus=="success"&&data!="error node"){
					var ret = eval("("+data+")"); 
					young.stock.series[0].addPoint([x, ret.edenUsed], true, true);
					young.stock.series[1].addPoint([x,ret.surivorUsed],true,true);
					old.stock.series[0].addPoint([x,ret.tenuredMax],true,true);
					old.stock.series[1].addPoint([x, ret.tenuredUsed], true, true);
					codecache.stock.series[0].addPoint([x,ret.codecacheMax],true,true);
					codecache.stock.series[1].addPoint([x,ret.codecacheUsed], true, true);
					permgen.stock.series[0].addPoint([x,ret.permgenMax],true,true);
					permgen.stock.series[1].addPoint([x,ret.permgenUsed], true, true);
				}else{}
		  }});
		}
	
	function gc(){
		if(!window.confirm("确定执行GC操作?"))return;
		$.ajax({type:"post", url:"AjaxServlet", data:{type:"gc",node:"<%=currentNode%>"},success:function(data,textStatus){
			if(textStatus="success"&&data!="error node"){
				alert('执行GC成功');
				var ret = eval("("+data+")"); 
				document.getElementById("gctime").innerHTML="GC时间: "+ret.gctime+" 毫秒";
				document.getElementById("gccount").innerHTML="GC次数: "+ret.gccount;
			}else if(data="error node"){
				alert('执行GC失败，请稍后再试!');
			}
	  }});
	}
	
	function monitor(){
		if(!window.confirm("确定执行监控操作?"))return;
		oTimer = setInterval(ajaxData, 1000);
		$("#monitorbt").css("display","none");
		$("#stopbt").css("display","block");
	}
	
	function stop(){
		window.clearInterval(oTimer);
		$("#monitorbt").css("display","block");
		$("#stopbt").css("display","none");
	}
	
	
</script>
</head>
<body>
	<div id="container">
    	<div id="header">
        	<h2>Sina App Engine Java  -    <%=SaeUserInfo.getAppName()%></h2>
   	 		<div id="topmenu">
            	<ul>
                	<li ><a href="index.jsp">Overview</a></li>
                	<li ><a href="appinfo.jsp">Application</a></li>
                    <li ><a href="monitor.jsp">Monitor</a></li>
                	<li class="current"><a href="memory.jsp">Memory</a></li>
                    <li><a href="threads.jsp">Threads</a></li>
              </ul>
          	</div>
      </div>
        <div id="wrapper">
            <div id="bigcontent">
       			<div id="rightnow">
                    <h3 class="reallynow">
                        <span>Monitor - <%=SaeUserInfo.getAppName() %>   </span>
                        <a  id="monitorbt" onclick="monitor()"  style="cursor:pointer;display: block;"><b>开始监控&nbsp;</b></a>
                        <a id="stopbt" onclick="stop()"  style="cursor:pointer;display: none;"><b>停止监控&nbsp;</b></a>
                        <a  onclick="gc()"  style="cursor:pointer;"><b>执行GC&nbsp;</b></a>
                        <br />
                    </h3>
				    <p class="youhave">
				    	<strong>节点名称: <%=nodename %> </strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>堆内存: <%=memoryMXBean.getHeapMemoryUsage().getMax()/(1024*1024)%>M</strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>非堆内存: <%=memoryMXBean.getNonHeapMemoryUsage().getMax()/(1024*1024)%>M</strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong id="gctime">GC时间: <%=gctime %> 毫秒</strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong id="gccount">GC次数:<%=gccount %> </strong>
                    </p>
			  </div>
			  <div id="infowrap">
              	<div id="biginfobox">
                    <h3>HeapMemory </h3>
                    <div id="heapmemory"  style="width:100%;height:240px;"></div>    
                     	<p class="youhave">&nbsp;
                     	<strong>Surivor Space: <%=surivorMax/(1024*1024) %>M</strong>
                     	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     	<strong>Eden Space: <%=edenMax/(1024*1024) %>M</strong>
                     	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     	<strong>Tenured Space: <%=tenuredMax/(1024*1024) %>M</strong>
                     	</p> 
                  </div>
                  
                  <div id="biginfobox" class="margin-left">
                    <h3>NonHeapMemory </h3>
                    <div id="nonheapmemory"  style="width:100%;height:240px;"></div>    
                    	<p class="youhave" style="text-align: center;">&nbsp;
                     	<strong>Perm Gen: <%=permMax/(1024*1024) %>M</strong>
                     	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     	<strong>Code Cache: <%=codeMax/(1024*1024) %>M</strong>
                     	</p> 
                   		
                  </div>
                  
                  <div id="biginfobox">
                    <h3>Young (KB)</h3>
                    <div id="young"  style="width:100%;height:250px;"></div>         
                  </div>
                  <div id="biginfobox" class="margin-left">
                    <h3>Old (KB)</h3>
                    <div id="old" style="width:100%;height:250px;"></div>     
                  </div>
                    <div id="biginfobox">
                    <h3>Code Cache (MB)</h3>
                    <div id="codecache"  style="width:100%;height:250px;"></div>         
                  </div>
                  <div id="biginfobox" class="margin-left">
                    <h3>Perm Gen(MB)</h3>
                    <div id="permgen" style="width:100%;height:250px;"></div>     
                  </div>
               </div><br>
            </div>
      </div>
</div>
</body>
</html>