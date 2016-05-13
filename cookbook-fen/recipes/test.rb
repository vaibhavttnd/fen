node['web_app']['user_name'] = "monitoring"
node['web_app']['group_name'] = "monitoring"
node['web_app']['user_dir'] = "/home/monitoring"



cookbook_file "#{node['web_app']['user_dir']}/ami_backup.sh" do
  source 'ami_backup.sh'
  mode 0700
  user node['web_app']['user_name']
  group node['web_app']['group_name']
  action :create
end

cookbook_file "#{node['web_app']['user_dir']}/ami_list.txt" do
  source 'ami_list.txt'
  mode 0700
  user node['web_app']['user_name']
  group node['web_app']['group_name']
  action :create
#  subscribes :action, "cookbook_file[#{node['web_app']['user_dir']}/ami_backup.sh]", :immediately
end


cookbook_file "#{node['web_app']['user_dir']}/ami_delete.sh" do
  source 'ami_delete.sh'
  mode 0700
  user node['web_app']['user_name']
  group node['web_app']['group_name']
  action :create
#  subscribes :action, "cookbook_file[#{node['web_app']['user_dir']}/ami_list.txt]", :immediately
end


