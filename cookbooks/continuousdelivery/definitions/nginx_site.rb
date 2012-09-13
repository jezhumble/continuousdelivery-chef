define :nginx_site, :enable => true do
  
  include_recipe "continuousdelivery::nginx"

  application_name = params[:name]

  if params[:enable]
    template "#{node[:nginx][:dir]}/sites-available/#{application_name}" do
      source params[:template]
      owner "root"
      group node[:nginx][:root_group]
      mode 0644
      variables(
                :application_name => application_name,
                :params => params
                )
      if ::File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{application_name}")
        notifies :reload, resources(:service => "nginx"), :delayed
      end
    end
  end
  
  if params[:enable]
    if (::File.exists?("#{node[:nginx][:dir]}/sites-available/#{application_name}") && !::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{application_name}")) then
      ::File.symlink("#{node[:nginx][:dir]}/sites-enabled/#{application_name}", "#{node[:nginx][:dir]}/sites-available/#{application_name}")
      notifies :restart, resources(:service => "nginx")
    end
  else
    if (::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{application_name}")) then
      ::File.unlink("#{node[:nginx][:dir]}/sites-enabled/#{application_name}")
      notifies :restart, resources(:service => "nginx")
    end
  end
end
