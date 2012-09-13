package "apache2"

service "apache2" do
  restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  action [ :enable ]
end

template "/etc/apache2/ports.conf" do
  source "apache2/ports.conf.erb"
  mode "0644"
  owner "root"
  group "root"

  notifies :restart, "service[apache2]"
end

package "libapache2-mod-rpaf"
package "libapache2-mod-php5"
package "php5-mysql"

execute "deactivate default site" do
  command "a2dissite default"
  action :run
end
