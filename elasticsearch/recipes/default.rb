###
### Cookbook Name:: elasticsearch
### Recipe:: default
###
### Copyright 2016, YOUR_COMPANY_NAME
###
### All rights reserved - Do Not Redistribute
###
##directory "/mnt/elastic" do
##	action :create
##end
##
##remote_file "/tmp/elasticsearch#{node['elastic']['version']}.tar.gz" do
##source "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.3/elasticsearch-2.3.3.tar.gz"	
#	#owner elastic
#	#group elastic
##end
##
##execute "extract tar file" do
#	#owner elastic
#	#group elastic
##	command "tar -xzf /tmp/elasticsearch#{node['elastic']['version']}.tar.gz   --strip-components=1 -C /mnt/elastic"
##end
#user "elastic" do
#	home "/mnt/home"
#	system	true
#	uid 1022
#end
template "/mnt/elastic/config/elasticsearch.yml" do
	source "elasticsearch.yml.erb"
	action :create
	mode 777
end
#
#include_recipe "elasticsearch::supervisor"
#
service "elastic" do
	start_command "supervisorctl start elastic"
	stop_command "supervisorctl stop elastic"
	restart_command "supervisorctl start elastic"
        supports :start => true, :stop => true, :restart => true, :reload => true
	action :stop
#	notifies :start, 'service[supervisor]', :immediately
end
#
cookbook_file "/etc/supervisor/conf.d/elastic.conf" do
	source "elastic.conf"
	mode	0755
	action :create
	notifies :stop, 'service[elastic]', :immediately
end
