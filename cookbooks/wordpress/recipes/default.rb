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
