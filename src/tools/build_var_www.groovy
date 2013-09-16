String dist_war = '/var/www/'
String war_dir = '../webroot/'

// ant builder
def ant = new AntBuilder()

ant.copy todir : dist_war, {
	fileset dir : war_dir
}