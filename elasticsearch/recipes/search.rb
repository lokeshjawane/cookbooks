graphite_servers = search(:node, 'recipes:"graphite"')

template "/tmp/collectd.conf" do
    source "collectd.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
        :graphite_servers => graphite_servers
    )
end
