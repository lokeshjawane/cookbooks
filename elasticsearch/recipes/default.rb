####
#### Cookbook Name:: elasticsearch
#### Recipe:: default
####
#### Copyright 2016, YOUR_COMPANY_NAME
####
#### All rights reserved - Do Not Redistribute
####
user "elastic" do
	home "/mnt/home"
	system	true
	uid 1022
end
directory "/mnt/elastic" do
	action :create
	owner "elastic"
end
##
remote_file "/tmp/elasticsearch#{node['elastic']['version']}.tar.gz" do
source "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.3/elasticsearch-2.3.3.tar.gz"	
	owner "elastic"
	group "elastic"
	not_if { File.exists?("/tmp/elasticsearch#{node['elastic']['version']}.tar.gz") }
end
##
execute "extract tar file" do
	user "elastic"
	command "tar -xzf /tmp/elasticsearch#{node['elastic']['version']}.tar.gz   --strip-components=1 -C /mnt/elastic"
	not_if { File.exist?("/mnt/elastic/config") }
end
service "elastic" do
	start_command "supervisorctl start elastic"
	stop_command "supervisorctl stop elastic"
	restart_command "supervisorctl restart elastic"
        supports :start => true, :stop => true, :restart => true, :reload => true
	action :nothing
#	notifies :start, 'service[supervisor]', :immediately
end
template "/mnt/elastic/config/elasticsearch.yml" do
	source "elasticsearch.yml.erb"
	owner "elastic"
	group "elastic"
	action [:create, :touch]
	mode 777
end

include_recipe "elasticsearch::supervisor"

##
cookbook_file "/etc/supervisor/conf.d/elastic.conf" do
	source "elastic.conf"
	mode	0755
	action [:create, :touch]
	notifies :restart, 'service[elastic]', :immediately
end
#execute "supervisorctl restart elastic" do
#    user "root"
#end
