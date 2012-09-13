define :apache2_site, :enable => true do
  
  include_recipe "continuousdelivery::apache2"

  application_name = params[:name]

  template "#{node[:apache2][:dir]}/sites-available/#{application_name}" do
    source params[:template]
    owner "root"
    group node[:apache2][:root_group]
    mode 0644
    variables(
      :application_name => application_name,
      :params => params
    )
    if ::File.exists?("#{node[:apache2][:dir]}/sites-enabled/#{application_name}")
      notifies :reload, resources(:service => "apache2"), :delayed
    end
  end
  
  if params[:enable]
    execute "a2ensite #{application_name}" do
      command "/usr/sbin/a2ensite #{application_name}"
      notifies :restart, resources(:service => "apache2")
      not_if do ::File.symlink?("#{node[:apache2][:dir]}/sites-enabled/#{application_name}") end
      only_if do ::File.exists?("#{node[:apache2][:dir]}/sites-available/#{application_name}") end
    end
  else
    execute "a2dissite #{application_name}" do
      command "/usr/sbin/a2dissite #{application_name}"
      notifies :restart, resources(:service => "apache2")
      only_if do ::File.symlink?("#{node[:apache2][:dir]}/sites-enabled/#{application_name}") end
    end
  end
end
