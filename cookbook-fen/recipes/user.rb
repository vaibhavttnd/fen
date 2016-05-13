
user 'monitoring' do
  comment 'Monitoring User'
  uid '1234'
#  gid '1234'
  home '/home/monitoring'
  shell '/bin/bash'
  supports :manage_home => true
  action :create
#  notifies :run, 'execute[switch-user]', :immediately
end

#notify this after user creation
#execute 'switch-user' do
#  command 'su - monitoring'
#  action :nothing
#  notifies :run, 'directory[/home/monitoring/.ssh]', :immediately 
#end

#################### User created
#notify this

node[:web_app][:user_name]='monitoring'
node['web_app']['group_name']='monitoring'
node['web_app']['user_dir']='/home/monitoring'

#directory "#{node['web_app']['user_dir']}/.ssh" do

directory "/home/monitoring/.ssh" do
  mode 0775
#  user node['web_app']['user_name']
  owner 'monitoring'
  group 'monitoring'
#  group node['web_app']['group_name']
  action :create
#  notifies :run, 'execute[switch-user]', :immediately 
end

####################  Directory created

cookbook_file "#{node[:web_app][:user_dir]}/.ssh/id_rsa2" do
  source 'id_rsa2'      ######## delete private.txt
#  cookbook 'fen-apache2'   ######## change it after testing
  mode 0600
  owner 'monitoring' #node['web_app']['user_name']
  group 'monitoring' #node['web_app']['group_name']
  action :create
#  subscribes :action, "directory[#{node['web_app']['user_dir']}/.ssh]", :immediately    #check this
end

#cookbook_file '/home/monitoring/.ssh/id_rsa2' do
#  source 'id_rsa2'
#  owner 'monitoring'
#  group 'monitoring'
#  mode '0755'
#  action :create
#end
####################  Private Key passed
