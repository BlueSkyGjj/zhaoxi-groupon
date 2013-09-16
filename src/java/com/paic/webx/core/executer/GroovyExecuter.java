package com.paic.webx.core.executer;

import groovy.lang.GroovyClassLoader;
import groovy.lang.GroovyCodeSource;
import groovy.lang.GroovyObject;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.codehaus.groovy.control.CompilationFailedException;
import org.codehaus.groovy.control.CompilerConfiguration;

import com.paic.webx.core.AppConf;
import com.paic.webx.core.AppPath;
import com.paic.webx.core.XActionException;
import com.paic.webx.tool.LManager;
import com.paic.webx.tool.cache.CacheServicer;
import com.paic.webx.tool.cache.ICache;

public class GroovyExecuter implements IExecuter {
	public final static String FILE_EXT = ".groovy";

	final Logger log = LManager.lprofiling();

	String encoding = "utf-8";
	// in the same jar by default
	// reset this to add new class paths not involved in container
	String scriptDir = "";
	boolean isParseSourceCache = true;
	boolean loadPerformanceDebug = false;

	static File getFile(String module) {
		String filePath = AppPath.getAppClassPath()
				+ module.replaceAll("\\.", "/") + FILE_EXT;
		return new File(filePath);
	}

	public static GroovyExecuter newInstance() {
		GroovyExecuter executer = new GroovyExecuter();
		executer.setScriptDir(AppPath.getAppClassPath());
		executer.setLoadPerformanceDebug("true".equals(AppConf
				.c("groovy_load_debug")));
		executer.setParseSourceCache("true".equals(AppConf
				.c("groovy_parse_cache")));
		return executer;
	}

	@SuppressWarnings("rawtypes")
	public Map<String, Object> exeXAction(File scriptFile, String action,
			Map<String, Object> params) throws XActionException {
		if (!scriptFile.exists() || scriptFile.isDirectory()
				|| !scriptFile.canRead())
			return null;

		CompilerConfiguration conf = new CompilerConfiguration();
		conf.setSourceEncoding(encoding);
		// set compile source flag
		conf.setRecompileGroovySource(false);

		// set groovy source directory as classpath
		// change the script source directory here
		if (scriptDir != null && !"".equals(scriptDir)) {
			List<String> cll = new ArrayList<String>();
			cll.add(scriptDir);
			conf.setClasspathList(cll);
		}

		try {
			long beginTime = System.currentTimeMillis();

			// XAction subclass
			GroovyCodeSource src = new GroovyCodeSource(scriptFile);
			String cacheKey = src.getName();
			String cacheKeyLastModified = cacheKey + "_lastModified";

			String lastModified = scriptFile.lastModified() + "";

			Class groovyClass = null;
			// use cache if last modify time not change
			if (isParseSourceCache) {
				ICache cache = CacheServicer.getInstance(null);

				String lastModifiedCached = (String) cache
						.get(cacheKeyLastModified);
				if (lastModified.equals(lastModifiedCached))
					groovyClass = (Class) cache.get(cacheKey);
			}

			if (groovyClass == null) {
				ClassLoader cl = getClass().getClassLoader();
				GroovyClassLoader groovyCl = new GroovyClassLoader(cl, conf);

				// groovy 1.6.9 jdk 4 bug (not cache actually)
				groovyClass = groovyCl.parseClass(src, isParseSourceCache);
				if (isParseSourceCache) {
					ICache cache = CacheServicer.getInstance(null);

					cache.put(cacheKeyLastModified, lastModified);
					cache.put(cacheKey, groovyClass);
				}
			}

			if (loadPerformanceDebug) {
				log.info("Load class - " + groovyClass.getName() + " : "
						+ (System.currentTimeMillis() - beginTime));
				beginTime = System.currentTimeMillis();
			}

			// static methods performance not improve as think
			// Class[] argsType = new Class[] { Map.class, Map.class };
			// Method methodInit = groovyClass.getMethod("init", argsType);
			// r = (Map) methodInit.invoke(null, args);
			// if (r == null) {
			// Method methodAction = groovyClass.getMethod(action, argsType);
			// // invoke target method
			// r = (Map) methodAction.invoke(null, args);
			// }

			// not static methods
			GroovyObject obj = (GroovyObject) groovyClass.newInstance();
			// invoke initialized method, return if result is not null
			@SuppressWarnings("unchecked")
			Map<String, Object> r = (Map<String, Object>) obj.invokeMethod(
					action, new Object[] { params });

			if (loadPerformanceDebug)
				log.info("Exe - " + groovyClass.getName() + "." + action
						+ " : " + (System.currentTimeMillis() - beginTime));

			return r;
		} catch (InstantiationException e) {
			throw new XActionException(e);
		} catch (IllegalAccessException e) {
			throw new XActionException(e);
		} catch (CompilationFailedException e) {
			throw new XActionException(e);
		} catch (IOException e) {
			throw new XActionException(e);
		} catch (Exception e) {
			throw new XActionException(e);
		}
	}

	public Map<String, Object> exeXAction(String module, String action,
			Map<String, Object> params) throws XActionException {
		return exeXAction(getFile(module), action, params);
	}

	public String getEncoding() {
		return encoding;
	}

	public void setEncoding(String encoding) {
		this.encoding = encoding;
	}

	public String getScriptDir() {
		return scriptDir;
	}

	public void setScriptDir(String scriptDir) {
		this.scriptDir = scriptDir;
	}

	public boolean isParseSourceCache() {
		return isParseSourceCache;
	}

	public void setParseSourceCache(boolean isParseSourceCache) {
		this.isParseSourceCache = isParseSourceCache;
	}

	public boolean isLoadPerformanceDebug() {
		return loadPerformanceDebug;
	}

	public void setLoadPerformanceDebug(boolean loadPerformanceDebug) {
		this.loadPerformanceDebug = loadPerformanceDebug;
	}
}
