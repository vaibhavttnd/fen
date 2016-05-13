
user 'monitoring' do
  comment 'Monitoring User'
#  uid '1234'
#  gid '1234'
  home '/home/monitoring'
  shell '/bin/bash'
end

#################### User created

node['web_app']['user_name'] = "monitoring"
node['web_app']['group_name'] = "monitoring"
node['web_app']['user_dir'] = "/home/monitoring"

directory "#{node['web_app']['user_dir']}/.ssh" do
  mode 0775
  user node['web_app']['user_name']
  group node['web_app']['group_name']
#  action :create
  subscribes :action, 'user[monitoring]', :immediately    #check this 
end

####################  Directory created

cookbook_file "#{node['web_app']['user_dir']}/.ssh/id_rsa" do
  source 'id_ed25519'
  cookbook 'fen-apache2'
  mode 0600
  user node['web_app']['user_name']
  group node['web_app']['group_name']
#  action :create
  subscribes :action, "directory[#{node['web_app']['user_dir']}/.ssh]", :immediately    #check this
end


####################  Private Key passed


