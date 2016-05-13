
cookbook_file "#{node['web_app']['user_dir']}/learning-cms-assets-code-deployment.sh" do
  source 'learning-cms-assets-code-deployment.sh'
  mode 0700
  user node['web_app']['user_name']
  group node['web_app']['group_name']
  action :create
end



include_recipe 'cron'
env = { AWS_DEFAULT_REGION: 'us-east-1' }
exepath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

cron_d 'learning-cms-assets-code-deployment' do
  comment 'learning-cms-assets-code-deployment every 15 days'
  environment env
  path exepath
  day '*/15'
  command 'bash /home/monitoring/learning-cms-assets-code-deployment.sh'
#  mailto 'system-alerts@fen.com'
end


