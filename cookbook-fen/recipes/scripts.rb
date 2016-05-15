node.default['web_app']['user_name'] = "monitoring"
node.default['web_app']['group_name'] = "monitoring"
node.default['web_app']['user_dir'] = "/home/monitoring"


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



################cron for ami_backup

include_recipe 'cron'
env = { AWS_DEFAULT_REGION: 'us-east-1' }
exepath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

cron_d 'ami_and_snapshot_ami_backup' do
  comment 'ami and snapshot backup every 15 days'
  environment env
  path exepath
  day '*/15'
  command 'bash /home/monitoring/ami_backup.sh'
#  mailto 'system-alerts@fen.com'
#  subscribes :action, "cookbook_file[#{node['web_app']['user_dir']}/ami_backup.sh]", :immediately
end


################ cron for ami_delete

cron_d 'ami_and_snapshot_deletion' do
  comment 'ami and snapshot deletion every 15 days'
  environment env
  path exepath
  day '*/15'
  command 'bash /home/monitoring/ami_delete.sh'
#  mailto 'system-alerts@fen.com'
#  subscribes :action, "cookbook_file[#{node['web_app']['user_dir']}/ami_delete.sh]", :immediately
end
