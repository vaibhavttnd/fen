

cookbook_file "/home/monitoring/ami_backup.sh" do
  source 'ami_backup.sh'
  mode 0700
  user 'monitoring'
  group 'monitoring' 
  action :create
end



include_recipe 'cron'
env = { AWS_DEFAULT_REGION: 'us-east-1' }
exepath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

cron 'ami_and_snapshot_ami_backup' do
  comment 'ami and snapshot backup every 15 days'
  environment env
  path exepath
  day '*/15'
  user 'monitoring'
  command 'bash /home/monitoring/ami_backups.sh'
#  mailto 'system-alerts@fen.com'
#  subscribes :action, "cookbook_file[#{node['web_app']['user_dir']}/ami_backup.sh]", :immediately
end

