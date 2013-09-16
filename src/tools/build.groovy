import groovy.grape.Grape

// ***** ***** ***** *****
// base paramters

// directory path defination
String base_dir = '../'
String app_name = 'webx'

String lib_dir = "E:/Workspace/webx-core/lib"

String dist_dir = "E:/Workspace/webx-core/dist"
String dist_war = dist_dir + '/' + app_name

// for sae
String dist_war_sae = ''

String src_dir_java = "${base_dir}/java"
String src_dir_groovy = "${base_dir}/groovy"

String i18n_dir = "${base_dir}/i18n"
String war_dir = "${base_dir}/webroot" 

String config_dir = "${base_dir}/config"
String config_dir_app = "${config_dir}/app"

// ant builder
def ant = new AntBuilder()

def t_build_gy = {
	ant.copy todir : dist_war + '/WEB-INF/classes', {
		fileset dir : src_dir_groovy
	}
}

// ***** ***** ***** ***** ***** *****
// build war
def t_build_war = {
	String dir_war_classes = dist_war + '/WEB-INF/classes'
	String dir_war_lib = dist_war + '/WEB-INF/lib'

	ant.mkdir dir : dist_war
	ant.mkdir dir : dir_war_classes
	ant.mkdir dir : dir_war_lib

	ant.copy todir : dir_war, {
		fileset dir : war_dir
	}

	ant.copy todir : dir_war_lib, {
		fileset dir : lib_dir
	}

	ant.copy todir : dir_war_classes, {
		fileset dir : config_dir_app, {
			exclude name : 'application.xml'
		}
	}

	ant.copy todir : dir_war_classes + '/i18n', {
		fileset dir : i18n_dir
	}
}

def t_build_war_simple = {
	ant.copy todir : dist_war, {
		fileset dir : war_dir
	}
}

def t_build_conf = {
	String dir_war_classes = dist_war + '/WEB-INF/classes'
	// copy config files
	ant.copy todir : dir_war_classes, overwrite: true, {
		fileset dir : config_dir_app
	}
}

def t_build_lib = {
	String dir_war_lib = dist_war + '/WEB-INF/lib'
	ant.copy todir : dir_war_lib, {
		fileset dir : lib_dir
	}
}

// ***** ***** ***** ***** ***** ***** ***** *****
// start run script here
if(args){
	String command = args[0]
	switch (command) {
		case 'gy':
			t_build_gy()
			break
		case 'war':
			t_build_war_simple()
			break
		case 'conf':
			t_build_conf()
			break
		case 'lib':
			t_build_lib()
			break
		default:
			t_build_gy()
			t_build_war_simple()
			t_build_conf()
			break
	}
}
