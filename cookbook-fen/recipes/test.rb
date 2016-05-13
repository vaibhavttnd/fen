

cookbook_file "/home/monitoring/ami_backup.sh" do
  source 'ami_backup.sh'
  mode 0700
  user 'monitoring'
  group 'monitoring' 
  action :create
end


