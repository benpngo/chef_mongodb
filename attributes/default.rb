# Default mongo repo
default['mongodb']['repo']['reponame'] = 'mongodb-enterprise'
default['mongodb']['repo']['description'] = 'MongoDB Enterprise Repository'
default['mongodb']['repo']['baseurl'] = 'https://repo.mongodb.com/yum/redhat/$releasever/mongodb-enterprise/3.2/$basearch/'
default['mongodb']['repo']['gpgkey'] = 'https://www.mongodb.org/static/pgp/server-3.2.asc'
default['mongodb']['repo']['gpgcheck'] = true


# Default package
default['mongodb']['mongodb_version'] = '3.2.15-1.el7'

# Service owner and group for mongo
default['mongodb']['user'] = 'mongo'
default['mongodb']['group'] = 'dba'


# Configuration options can be found at https://docs.mongodb.com/manual/reference/configuration-options/

# Set the default required values for mongod
# Each default is a core setting
default['mongodb']['configuration']['systemLog'] = {
	'destination'		=> 'file',
	'logAppend'			=> 'true',
	'path'					=> '/u01/log/mongod.log'
}
default['mongodb']['configuration']['storage'] = {
	'dbPath'				=> '/u01/data',
	'engine'				=> 'mmapv1',
	'journal'				=> {
		'enabled'				=> 'true'
	}
}
default['mongodb']['configuration']['processManagement'] = {
	'fork'					=> 'true',
	'pidFilePath'		=> '/var/run/mongodb/mongod.pid'
}
default['mongodb']['configuration']['net'] = {
	'port'					=> '27017',
	'bindIp'				=> "#{node['ipaddress']},127.0.0.1"
}

# If these core options do not have settings the service fails

#default['mongodb']['configuration']['security'] = {}
#default['mongodb']['configuration']['operationProfiling'] = {}
#default['mongodb']['configuration']['replication'] = {}
#default['mongodb']['configuration']['sharding'] = {}
#default['mongodb']['configuration']['auditLog'] = {}
#default['mongodb']['configuration']['snmp'] = {}
