#
# Cookbook Name:: 'mongodb_cpos'
# Recipe:: default
#
#

# Configure mongodb repository
# This resource adds to /etc/yum.repos.d/ the mongodb enterprise org repo to the server
yum_repository "#{node['mongodb']['repo']['reponame']}" do
  description "#{node['mongodb']['repo']['description']}"
  baseurl "#{node['mongodb']['repo']['baseurl']}"
  gpgkey "#{node['mongodb']['repo']['gpgkey']}"
  gpgcheck node['mongodb']['repo']['gpgcheck']
  action :create
end

# Install the mongodb database software from rpm package mongodb-enterprise
package 'mongodb-enterprise' do
    version "#{node['mongodb']['mongodb_version']}"
end

# Reload the daemon after making changes
execute 'daemon-reload' do
    command '/bin/systemctl daemon-reload'
  action :nothing
end
# Edit the service owner for systemd service
ruby_block 'Edit service owner' do
    block do
        file = Chef::Util::FileEdit.new('/etc/rc.d/init.d/mongod')
        file.search_file_replace(/(^MONGO_USER=)(.*)/, "\\1#{node['mongodb']['user']}")
        file.search_file_replace(/(^MONGO_GROUP=)(.*)/, "\\1#{node['mongodb']['group']}")
        #file.search_file_replace(/\smongod:mongod\s/, "\s#{node['mongodb']['user']}:#{node['mongodb']['group']}\s")
        file.write_file
    end
    notifies :run, 'execute[daemon-reload]', :immediately
    only_if {
        ::File.exist?('/etc/rc.d/init.d/mongod') &&
        ( 
            ! (::File.read('/etc/rc.d/init.d/mongod')).match(/^MONGO_USER=#{node['mongodb']['user']}/) ||
            ! (::File.read('/etc/rc.d/init.d/mongod')).match(/^MONGO_GROUP=#{node['mongodb']['group']}/)
        )
    }
end

# Dyanamically generate the config file for mongodb based on attributes defined, also notify the mongod service to restart if the config file has been changed
template '/etc/mongod.conf' do
    source 'mongod.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    #notifies :restart, 'service[mongod]', :delayed
end

# Set the mongod service to enable
service 'mongod' do
    service_name "mongod.service"
    action [:enable, :start]
end