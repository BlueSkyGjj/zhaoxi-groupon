package ctrl

import org.apache.log4j.Logger

import biz.db.*

class TestTask {
	Logger log = Logger.getLogger(TestTask.class)

	def void exe(Map params){
		log.info('test task')
	}

	// send email
	def void sendEmailBatch(Map params){
		def dao = XDAO.gen()
		def item = dao.queryMap('select * from t_email_queue where status = 0 limit 1')
		if(!item){
			log.info('Skip send email as queue is blank!')
			return
		}

		try{
			log.info('Begin send email in queue : ' + item.id)
			Utils.sendEmailBatch(item)
			dao.update([id: item.id, status: 1, sendDd: new Date()], 't_email_queue', '')
			log.info('End send email in queue : ' + item.id)
		}catch(ex){
			log.error('Failed send email in queue : ' + item.id, ex)
		}
	}
}