<%@page import="java.lang.management.RuntimeMXBean"%>
<%@page import="java.lang.management.MemoryMXBean"%>
<%@page import="java.lang.management.ManagementFactory"%>
<%@page import="java.util.Date"%>
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
<script type="text/javascript" src="js/jquery-1.7.1.js"></script>
<script src="js/highstock.js"></script>
<script src="js/exporting.js"></script>
<script src="js/chartsutil.js"></script>

<!--[if IE]>
<link rel="stylesheet" type="text/css" href="css/ie-sucks.css" />
<![endif]-->
 
 	<%
 	MemoryMXBean memoryMXBean =  ManagementFactory.getMemoryMXBean();
 	RuntimeMXBean rMXBean = ManagementFactory.getRuntimeMXBean();	
 	String [] node = rMXBean.getName().split("@");//节点名称
 	String nodename = node[node.length-1];
 	String currentNode = nodename+request.getLocalPort();
 	%>
	<script type="text/javascript">
	var heap,nonheap,loadclass,thread,oTimer;
	$(function() {
		Highcharts.setOptions({global : {useUTC : false,title : null,exporting: {enabled: false}}});
		heap = new StockChartWrap("heapmemory",{load : function() {ajaxData();}},"commited memory","used memory");
		nonheap = new StockChartWrap("nonheapmemory",null,"commited memory","used memory");
		loadclass = new StockChartWrap("classmonitor",null,"loaded class","unloaded class");
		thread = new StockChartWrap("threadmonitor",null,"thread count","daemon thread count");
	});
	
	function ajaxData(){
		var x = (new Date()).getTime(); // current time
		$.ajax({type:"post", url:"ajax.jsp", data:{type:"monitor",node:"<%=currentNode %>"},success:function(data,textStatus){
				if(textStatus=="success"&&data!="error node"){
					var ret = eval("("+data+")"); 
					heap.stock.series[1].addPoint([x, ret.heapUsed], true, true);
					heap.stock.series[0].addPoint([x,ret.heapCommit],true,true);
					nonheap.stock.series[1].addPoint([x, ret.nonheapUsed], true, true);
					nonheap.stock.series[0].addPoint([x,ret.nonheapCommit],true,true);
					loadclass.stock.series[0].addPoint([x, ret.loadclassCount], true, true);
					loadclass.stock.series[1].addPoint([x,ret.unloadclassCount],true,true);
					thread.stock.series[0].addPoint([x, ret.threadCount], true, true);
					thread.stock.series[1].addPoint([x,ret.daemonthreadCount],true,true);
				}else{}
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
                    <li class="current"><a href="monitor.jsp">Monitor</a></li>
                	<li><a href="memory.jsp">Memory</a></li>
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
                        <br />
                    </h3>
				    <p class="youhave">
				    	<strong>节点名称: <%=nodename %></strong>
                    </p>
			  </div>
			  <div id="infowrap">
              	<div id="biginfobox">
                    <h3>HeapMemory(KB) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Max: <%=memoryMXBean.getHeapMemoryUsage().getMax()/1024  %>KB</h3>
                   		<div id="heapmemory"  style="width:100%;height:250px;"></div>    
                  </div>
                  
                  <div id="biginfobox" class="margin-left">
                    <h3>NonHeapMemory(KB) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Max: <%=memoryMXBean.getNonHeapMemoryUsage().getMax()/1024%>KB</h3>
                   		<div id="nonheapmemory"  style="width:100%;height:250px;"></div>    
                  </div>
                  <div id="biginfobox">
                    <h3>Class</h3>
                    <div id="classmonitor"  style="width:100%;height:250px;"></div>         
                  </div>
                  <div id="biginfobox" class="margin-left">
                    <h3>Thread</h3>
                    <div id="threadmonitor" style="width:100%;height:250px;"></div>     
                  </div>
               </div><br>
            </div>
      </div>
</div>
</body>
</html>