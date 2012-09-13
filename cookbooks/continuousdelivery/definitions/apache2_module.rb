define :apache2_module, :enable => true, :conf => false do

  include_recipe "continuousdelivery::apache2"

  if params[:enable]
    execute "a2enmod #{params[:name]}" do
      command "/usr/sbin/a2enmod #{params[:name]}"
      notifies :restart, resources(:service => "apache2")
      not_if do (::File.symlink?("#{node[:apache2][:dir]}/mods-enabled/#{params[:name]}.load") and
                 ((::File.exists?("#{node[:apache2][:dir]}/mods-available/#{params[:name]}.conf"))?
                  (::File.symlink?("#{node[:apache2][:dir]}/mods-enabled/#{params[:name]}.conf")):(true)))
      end
    end
  else
    execute "a2dismod #{params[:name]}" do
      command "/usr/sbin/a2dismod #{params[:name]}"
      notifies :restart, resources(:service => "apache2")
      only_if do ::File.symlink?("#{node[:apache2][:dir]}/mods-enabled/#{params[:name]}.load") end
    end
  end
end
