# This installs all the necessary bits and pieces to run the continuousdelivery.com site
# It assumes you're running Ubuntu 12.04 LTS "Precise"
# You should create a user with sudo rights before running this, as it turns off the ability to ssh in as root
# Based on http://wordpress.stackexchange.com/questions/2490/what-is-the-best-caching-option-for-wordpress-multi-site-on-non-shared-hosting
# Copyright 2012 Jez Humble
# Licensed under the BSD 2-line license

package "nginx"

service "nginx" do
  supports "default" => [ :restart, :reload, :status ];
  action [ :enable, :start ]
end

service "ssh" do
  service_name "ssh"
  supports "default" => [ :restart, :reload, :status ];
  action [ :enable, :start ]
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  mode "0644"
  owner "root"
  group "root"

  notifies :restart, "service[ssh]"
end
