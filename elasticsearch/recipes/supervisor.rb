%w{supervisor wget curl}.each do |p|
package p
end

service "supervisor" do
	start_command "service supervisor start"
stop_command "service supervisor start"
	restart_command "service supervisor restart"
	supports :start => true, :stop => true, :restart => true, :reload => true
	action [ :enable, :start ]
end
