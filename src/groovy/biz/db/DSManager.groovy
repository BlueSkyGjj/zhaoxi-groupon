package biz.db

import com.paic.webx.core.AppContext
import com.paic.webx.tool.LManager

import javax.sql.DataSource

//import javax.transaction.TransactionManager
//import weblogic.transaction.TransactionHelper

import org.springframework.jdbc.datasource.DataSourceTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.support.DefaultTransactionDefinition

class DSManager {
	/**
	  public static final int PROPAGATION_REQUIRED = 0;
	  public static final int PROPAGATION_SUPPORTS = 1;
	  public static final int PROPAGATION_MANDATORY = 2;
	  public static final int PROPAGATION_REQUIRES_NEW = 3;
	  public static final int PROPAGATION_NOT_SUPPORTED = 4;
	  public static final int PROPAGATION_NEVER = 5;
	  public static final int PROPAGATION_NESTED = 6;
	  public static final int ISOLATION_DEFAULT = -1;
	  public static final int ISOLATION_READ_UNCOMMITTED = 1;
	  public static final int ISOLATION_READ_COMMITTED = 2;
	  public static final int ISOLATION_REPEATABLE_READ = 4;
	  public static final int ISOLATION_SERIALIZABLE = 8;
	  public static final int TIMEOUT_DEFAULT = -1;
	*/

	static log = LManager.laudit()

	// use spring platform indenpendent TransactionManager
	static DataSourceTransactionManager getTm(){
		def context = AppContext.getContext()
		return context.getBean('transactionManager')
	}

	static void withTrans(String type, Closure callback){
		def tm = getTm()
		def transDef = new DefaultTransactionDefinition(TransactionDefinition[type])
		def status = tm.getTransaction(transDef)
		try {
			callback.call()
			tm.commit(status)
		}catch (ex) {
			log.error('DSManager withTrans failed!', ex)

			tm.rollback(status)
			throw ex
		}
	}
	static void withTrans(Closure callback){
		withTrans('PROPAGATION_REQUIRED', callback)
	}

	// user weblogic TransactionManager when use jndi datasource
	// deprecated
	/*
	static TransactionManager getWlTm(){
		return TransactionHelper.getTransactionHelper().getTransactionManager()
	}

	static void withWlTrans(Closure callback){
		def tm = getWlTm()
		tm.begin()
		try {
			callback.call()
			tm.commit()
		}catch (ex) {
			log.error('DSManager withWlTrans failed!', ex)

			tm.rollback()
			throw ex
		}
	}
	*/
}