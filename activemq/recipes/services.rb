service "activemq" do
	start_command "/mnt/activemq/apache-activemq-#{node['active']['version']}/bin/activemq start"
	stop_command "/mnt/activemq/apache-activemq-#{node['active']['version']}/bin/activemq stop"
	restart_command "/mnt/activemq/apache-activemq-#{node['active']['version']}/bin/activemq restart"
	supports :start => true, :stop => true, :restart => true
	action :nothing
end
