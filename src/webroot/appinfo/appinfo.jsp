<%@page import="java.lang.management.ThreadInfo"%>
<%@page import="com.sina.sae.util.SaeUserInfo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.lang.management.ThreadMXBean"%>
<%@page import="java.lang.management.CompilationMXBean"%>
<%@page import="java.lang.management.OperatingSystemMXBean"%>
<%@page import="java.lang.management.GarbageCollectorMXBean"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.management.MemoryUsage"%>
<%@page import="java.lang.management.MemoryMXBean"%>
<%@page import="java.lang.management.ClassLoadingMXBean"%>
<%@page import="java.lang.management.RuntimeMXBean"%>
<%@page import="java.lang.management.ManagementFactory"%>
<%@page import="java.util.Date"%>
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
<script src="js/highcharts.js"></script>
<script src="js/exporting.js"></script>
<script src="js/chartsutil.js"></script>
<!--[if IE]>
<link rel="stylesheet" type="text/css" href="css/ie-sucks.css" />
<![endif]-->
<%!
	public static String formatDuring(long mss) {  
	    long hours = mss / (1000 * 60 * 60);  
	    long minutes = (mss % (1000 * 60 * 60)) / (1000 * 60);  
	    long seconds = (mss % (1000 * 60)) / 1000;  
	    return   hours + " 小时 " + minutes + " 分钟 "  
	            + seconds + " 秒 ";  
	}
%>
<%

	RuntimeMXBean rMXBean = ManagementFactory.getRuntimeMXBean();
	ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();
	CompilationMXBean cMXBean =	ManagementFactory.getCompilationMXBean();
	ClassLoadingMXBean aClassLoadingMXBean = ManagementFactory.getClassLoadingMXBean();
	MemoryMXBean aMemoryMXBean = ManagementFactory.getMemoryMXBean();
	List<GarbageCollectorMXBean> aGCMXBeans = ManagementFactory.getGarbageCollectorMXBeans();
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String [] node = rMXBean.getName().split("@");//节点名称
	String runtime = formatDuring(rMXBean.getUptime());//运行时间
	long cputime = threadMXBean.getCurrentThreadCpuTime()/1000000;//cpu时间
	String jvmname = rMXBean.getVmName();//jvm名称
	String jitname = cMXBean.getName();//编译器成名称
	long  jittime = cMXBean.getTotalCompilationTime()/1000;//编译时间
	long  nowload = aClassLoadingMXBean.getTotalLoadedClassCount();//当前载总数
	long  loaded = aClassLoadingMXBean.getLoadedClassCount();//类总加载
	long  unload  = aClassLoadingMXBean.getUnloadedClassCount();//写在类数
	String javaversion = System.getProperty("java.version");
	long livethread = threadMXBean.getThreadCount();//活动线程数
	long topthread = threadMXBean.getPeakThreadCount();//峰值线程数
	long deamonthread = threadMXBean.getDaemonThreadCount();//守护线程数
	long totalthread = threadMXBean.getTotalStartedThreadCount();//创建线程总数
	long [] ids = threadMXBean.getAllThreadIds();//所有线程ID号
	//计算各类状态线程数量
	long newcount=0,runcount=0,blockedcount=0,waitingcount=0,twaitcount=0,terminatedcount=0;
	for(int i=0;i<ids.length;i++){
		ThreadInfo tInfo =  threadMXBean.getThreadInfo(ids[i]);
		Thread.State state = tInfo.getThreadState();
		if(state.equals(Thread.State.NEW)){
			newcount++;
		}else if(state.equals(Thread.State.RUNNABLE)){
			runcount++;
		}else if(state.equals(Thread.State.BLOCKED)){
			blockedcount++;
		}else if(state.equals(Thread.State.WAITING)){
			waitingcount++;
		}else if(state.equals(Thread.State.TIMED_WAITING)){
			twaitcount++;
		}else if(state.equals(Thread.State.TERMINATED)){
			terminatedcount++;
		}
	}
	//堆内存情况
	MemoryUsage hMemoryUsage = aMemoryMXBean.getHeapMemoryUsage();
	long hmax = hMemoryUsage.getMax();
	long hinit = hMemoryUsage.getInit();
	long hused = hMemoryUsage.getUsed();
	long hcommited = hMemoryUsage.getCommitted();
	long husedper = 100*hused/hmax;
	long hunusedper = 100 - husedper;
	//非堆内存情况
	MemoryUsage aMemoryUsage = aMemoryMXBean.getNonHeapMemoryUsage();
	long amax = aMemoryUsage.getMax();
	long ainit = aMemoryUsage.getInit();
	long aused = aMemoryUsage.getUsed();
	long acommited = aMemoryUsage.getCommitted();
	long ausedper = 100*aused/amax;
	long aunusedper = 100-ausedper;
%>
<script type="text/javascript">
	$(function () {
	    $(document).ready(function() {
			new HighchartsPieWrap("hmemory","Heap Percent",[['unused', <%=hunusedper%>],{name: 'used', y: <%=husedper%>,sliced: true,selected: true}]);
			new HighchartsPieWrap("nmemory","NonHeap Percent",[['unused', <%=aunusedper%>],{name: 'used',y: <%=ausedper%>,sliced: true,selected: true}]);
		});
	});
</script>
</head>
<body>
	<div id="container">
    	<div id="header">
        	<h2>Sina App Engine Java  -    <%=SaeUserInfo.getAppName()%></h2>
   	 		<div id="topmenu">
            	<ul>
                	<li ><a href="index.jsp">Overview</a></li>
                	<li class="current"><a href="appinfo.jsp">Application</a></li>
                    <li><a href="monitor.jsp">Monitor</a></li>
                	<li><a href="memory.jsp">Memory</a></li>
                    <li><a href="threads.jsp">Threads</a></li>
              </ul>
          	</div>
      </div>
        <div id="wrapper">
            <div id="bigcontent">
       			<div id="rightnow">
                    <h3 class="reallynow">
                        <span>App Info  -  <%=SaeUserInfo.getAppName() %></span>
                        <a href="appinfo.jsp" ><b>Refresh All</b>&nbsp;</a>
                        <br />
                    </h3>
				    <p class="youhave">
				    	<strong>节点名称: <%=node[node.length-1] %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>当前时间：<%=sdf.format(new Date()) %></strong> 
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>运行时间: <%=runtime %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>CPU时间: <%=cputime/1000  %>秒</strong> <br/> 
                    </p>
			  </div>
			  <br/>
			  <div id="rightnow">
                    <h3 class="reallynow">
                        <span>JVM  </span>
                        <br />
                    </h3>
				    <p class="youhave">
				    	<strong>JDK 版本: <%=javaversion %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				    	<strong> Java虚拟机: <%=jvmname %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>编译器：<%=jitname %></strong> 
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>编译时间: <%=jittime %> 秒</strong>
				    	<br/><br/>
				    	<strong>已加载类: <%=loaded  %></strong> 
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>当前加载类: <%=nowload %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>卸载类: <%=unload %></strong>
				    	<br/>
                    </p>
			  </div>
			   <br/>
			   
			  <div id="rightnow">
                    <h3 class="reallynow">
                        <span>Thread  </span>
                        <br />
                    </h3>
				    <p class="youhave">
				    	<strong>创建线程总数: <%=totalthread %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				    	<strong> 活动线程数: <%=livethread %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>峰值线程数：<%=topthread %></strong> 
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>守护线程数: <%=deamonthread %> </strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>线程CPU时间: <%=cputime %>毫秒 </strong>
				    	<br/><br/>
				    	<strong>NEW线程: <%=newcount  %></strong> 
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>RUNNABLE线程: <%=runcount %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>BLOCKED线程: <%=blockedcount %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>WATTING线程: <%=waitingcount %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>TIMED_WATTING线程: <%=twaitcount %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>TERMINATED线程: <%=terminatedcount %></strong>
				    	<br/>
                    </p>
			  </div>
               <br/>
			  <div id="rightnow">
                    <h3 class="reallynow">
                        <span>GC  </span>
                        <br />
                    </h3>
				   <p class="youhave">
				    	<%
				    		for(GarbageCollectorMXBean aGCMXBean:aGCMXBeans){
				    	%>
				    	<strong>垃圾收集器: <%=aGCMXBean.getName() %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				    	<strong>收集次数: <%=aGCMXBean.getCollectionCount() %></strong>
				    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    	<strong>收集时间：<%=aGCMXBean.getCollectionTime() %>毫秒</strong> 
				    	<br/><br/>
				    	<%} %>
                    </p>
			  </div>
                <div id="infowrap" style="display: block;height: 390px;">
              	<div id="biginfobox">
                    <h3>HeapMemory  </h3>
                    <p class="youhave">
                    	&nbsp;&nbsp;<strong>init: <%=hinit/1024%>K</strong>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    	<strong>used: <%=hused/1024%>K</strong>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    	<strong>committed : <%=hcommited/1024%>K</strong>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    	<strong>max: <%=hmax/1024%>K</strong>
                    </p>      
                    <br/> 
                    <div id="hmemory" style="width:100%;height:300px;"></div>     
                  </div>
                  <div id="biginfobox" class="margin-left">
                    <h3>NonHeapMemory  </h3>
                    <p class="youhave">
                    	&nbsp;&nbsp;<strong>init: <%=ainit/1024%>K</strong>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    	<strong>used: <%=aused/1024%>K</strong>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                    	<strong>committed : <%=acommited/1024%>K</strong>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                    	<strong>max: <%=amax/1024%>K</strong>
                    </p>       
                    <br/>
                    <div id="nmemory" style="width:100%;height:300px;"></div>     
                  </div>
               </div>
            </div>
      </div>
</div>
</body>
</html>