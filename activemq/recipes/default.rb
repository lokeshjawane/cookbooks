#
# Cookbook Name:: activemq
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'activemq::services'

user "activemq" do
	home "/mnt/activemq"
	manage_home true
	shell "/bin/bash"
	uid 1023
	action :create
	system true
end

directory "/mnt/activemq/apache-activemq-#{node['active']['version']}" do
	owner "activemq"
	group "activemq"
	action :create
end

remote_file "/tmp/apache-activemq-#{node['active']['version']}-bin.tar.gz" do
	source "http://archive.apache.org/dist/activemq/#{node['active']['version']}/apache-activemq-#{node['active']['version']}-bin.tar.gz"
	owner "activemq"
	action :create
	not_if{File.exists?("/tmp/apache-activemq-#{node['active']['version']}-bin.tar.gz")}
end

execute "Extract tar to /mnt/activemq/apache-activemq-#{node['active']['version']}" do
	user "activemq"
	command "tar -xzf /tmp/apache-activemq-#{node['active']['version']}-bin.tar.gz -C /mnt/activemq/apache-activemq-#{node['active']['version']}  --strip-components=1"
	notifies :restart, 'service[activemq]', :immediate
end
