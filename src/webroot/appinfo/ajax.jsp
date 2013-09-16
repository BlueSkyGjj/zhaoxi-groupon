<%@ page language="java"   pageEncoding="utf-8" import="java.lang.management.RuntimeMXBean,java.lang.management.ThreadInfo,java.lang.management.GarbageCollectorMXBean,java.lang.management.ThreadMXBean,java.lang.management.ClassLoadingMXBean,java.lang.management.MemoryMXBean,java.lang.management.MemoryUsage,java.lang.management.MemoryPoolMXBean,java.util.List,java.lang.management.ManagementFactory"%>
<%
	response.setContentType("text/html;charset=utf-8");
	String node = request.getParameter("node");
	String type = request.getParameter("type");
	StringBuilder json = new StringBuilder();
	long MSIZE = 1024*1024;
	try {
		RuntimeMXBean runtimeMXBean = ManagementFactory.getRuntimeMXBean();
		String runtimeName = runtimeMXBean.getName();
		String [] requestNode = runtimeName.split("@");//节点名称
		String cureentNode = requestNode[requestNode.length-1] + request.getLocalPort();//当前节点
		if(cureentNode.equals(node)){//保证请求数据来自同一节点 ajax类型 
			if("memory".equals(type)){
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
			 	json.append("{edenUsed:").append(eden.getUsed()/1024).append(",surivorUsed:").append(surivor.getUsed()/1024)
			 	.append(",tenuredUsed:").append(tenured.getUsed()/1024).append(",tenuredMax:").append(tenured.getMax()/1024)
			 	.append(",codecacheUsed:").append(code.getUsed()/MSIZE).append(",codecacheMax:").append(code.getMax()/MSIZE)
			 	.append(",permgenUsed:").append(perm.getUsed()/MSIZE).append(",permgenMax:").append(perm.getMax()/MSIZE).append("}");
			}else if("monitor".equals(type)){
				MemoryMXBean aMemoryMXBean = ManagementFactory.getMemoryMXBean();
				MemoryUsage heap = aMemoryMXBean.getHeapMemoryUsage();
				MemoryUsage nonHeap = aMemoryMXBean.getNonHeapMemoryUsage();
				ClassLoadingMXBean loadingMXBean = ManagementFactory.getClassLoadingMXBean();
				ThreadMXBean threadMXBean =  ManagementFactory.getThreadMXBean();
				json.append("{").append("heapUsed:").append(heap.getUsed()/1024).append(",heapCommit:").append(heap.getCommitted()/1024)
				.append(",nonheapUsed:").append(nonHeap.getUsed()/1024).append(",nonheapCommit:").append(nonHeap.getCommitted()/1024)
				.append(",threadCount:").append(threadMXBean.getThreadCount()).append(",daemonthreadCount:").append(threadMXBean.getDaemonThreadCount())
				.append(",loadclassCount:").append(loadingMXBean.getLoadedClassCount()).append(",unloadclassCount:").append(loadingMXBean.getUnloadedClassCount()).append("}");
			}else if("gc".equals(type)){
				System.gc();
				//GC情况
				List<GarbageCollectorMXBean> aGCMXBeans = ManagementFactory.getGarbageCollectorMXBeans();
				long gccount = 0,gctime=0;
				for(GarbageCollectorMXBean aGCMXBean:aGCMXBeans){
					gccount = gccount + aGCMXBean.getCollectionCount();
					gctime = gctime + aGCMXBean.getCollectionTime() ;
				}
				json.append("{gccount:").append(gccount).append(",gctime:").append(gctime).append("}");
			}if("threads".equals(type)){
				String threadId = request.getParameter("threadId");
				ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();
				ThreadInfo threadInfo = threadMXBean.getThreadInfo(Long.parseLong(threadId),Integer.MAX_VALUE);
				json.append("请求节点:&nbsp;&nbsp;").append(requestNode[requestNode.length-1]).append("<br/><br/>")
				.append("线程名称:&nbsp;&nbsp;").append(threadInfo.getThreadName()).append("<br/><br/>")
				.append("线程状态:&nbsp;&nbsp;").append(threadInfo.getThreadState()).append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
				.append("CPU时间: ").append(threadMXBean.getThreadCpuTime(threadInfo.getThreadId())/(1000*1000)).append("ms&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
				.append("阻塞总数:&nbsp;&nbsp;").append(threadInfo.getBlockedCount()).append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;等待总数:&nbsp;&nbsp;")
				.append(threadInfo.getWaitedCount()).append("<br><br>堆栈跟踪:&nbsp;&nbsp;<br><br>");
				for (StackTraceElement e : threadInfo.getStackTrace()){
					if(!threadInfo.getThreadName().startsWith("Sae"))
						json.append("&nbsp;").append(e.toString()).append("<br>");
				}
			
			}
		}else{
				json.append("error node");
		}
		//System.out.println("#error node#:request node:"+node+"   current node:"+cureentNode);
		out.println(json);
	} catch (Exception e) {
		System.err.print(e.getMessage());
		out.println(e.getMessage());
		e.printStackTrace();
	}
	//out.flush();
	//out.close();
%>
