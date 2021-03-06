# This installs all the necessary bits and pieces to run the continuousdelivery.com site
# It assumes you're running Ubuntu 12.04 LTS "Precise"
# You should create a user with sudo rights before running this, as it turns off the ability to ssh in as root
# Based on http://wordpress.stackexchange.com/questions/2490/what-is-the-best-caching-option-for-wordpress-multi-site-on-non-shared-hosting
# Also lots of stuff taken from https://github.com/opscode-cookbooks/
# Copyright 2012 Jez Humble
# Licensed under the Apache 2 license

package "mysql-server-5.5"

service "mysql-server-5.5" do
  restart_command "restart mysql"
  stop_command "stop mysql"
  start_command "start mysql"
  supports "default" => [ :restart, :reload, :status ]
  action [ :nothing ]
end

service "ssh" do
  service_name "ssh"
  supports "default" => [ :restart, :reload, :status ]
  action [ :enable, :start ]
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  mode "0644"
  owner "root"
  group "root"

  notifies :restart, "service[ssh]"
end

apache2_module "rewrite"
apache2_module "ssl"

apache2_site "continuousdelivery" do
  template "apache2/apache2_site.erb"
  server_name "continuousdelivery.com"
  server_port "8080"
  server_aliases ["www.continuousdelivery.com", "guide.continuousdelivery.com"]
  docroot "/var/www/continuousdelivery"
end

nginx_site "continuousdelivery" do
  template "nginx/nginx_wp_site.erb"
  server_name "continuousdelivery.com"
  server_ip "*"
  server_port "80"
  server_aliases ["www.continuousdelivery.com", "guide.continuousdelivery.com"]
  upstream_server_port "8080"
end  

apache2_site "jezhumble" do
  template "apache2/apache2_site.erb"
  server_name "jezhumble.net"
  server_port "8080"
  server_aliases ["www.jezhumble.net", "blog.jezhumble.net"]
  docroot "/var/www/jezhumble"
end

nginx_site "jezhumble" do
  template "nginx/nginx_wp_site.erb"
  server_name "jezhumble.net"
  server_ip "*"
  server_port "80"
  server_aliases ["www.jezhumble.net", "blog.jezhumble.net"]
  upstream_server_port "8080"
end  

apache2_site "subversion" do
  server_name "jezhumble.net"
  template "apache2/apache2_ssl_site.erb"
  svn_root "/var/subversion"
  svn_path "/svn"
  docroot "/var/www/subversion"
  auth_file "/etc/apache2/dav_svn.auth"
  ssl_cert_file "/etc/apache2/ssl/jezhumble.net.cert"
  ssl_cert_key_file "/etc/apache2/ssl/jezhumble.net.key"
end
