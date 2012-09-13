package "nginx"

service "nginx" do
  supports "default" => [ :restart, :reload, :status ]
  action [ :enable, :start ]
end

nginx_site "default" do
  enable false
end
