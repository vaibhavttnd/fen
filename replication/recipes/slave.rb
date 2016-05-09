service "mysql" do
  action :stop
  notifies :run, 'execute[copy]', :immediately
  action :nothing
end


execute 'copy' do
 command 'cp -a /home/ubuntu/base/. /var/lib/mysql/'
 notifies :run, 'execute[master]', :immediately
 action :nothing
end


execute 'master' do
#add ip
 command 'mysql --host=52.207.252.240 --user=repl --password=v'
 notifies :run, 'execute[sed]', :immediately
 action :nothing
end

#template can be added
#check the spacing in my.cnf of server-id
execute 'sed' do
 command "sed -i 's/server-id=1/server-id=2/' /etc/mysql/my.cnf"
 notifies :run, 'execute[mysql-start]', :immediately
 action :nothing
end


execute 'mysql-start' do
 command "service mysql start"
# notifies :run, 'execute[install]', :immediately
 action :nothing
end


#template can be used
#Note MASTER_LOG_FILE, MASTER_LOG_POSTION before replication
file '/home/ubuntu/bin-log.sql' do
  content "CHANGE MASTER TO MASTER_HOST='52.207.252.240',MASTER_USER='repl',MASTER_PASSWORD='v',MASTER_LOG_FILE='mysql-bin.000001',MASTER_LOG_POS=;START SLAVE;"
#add data
  mode '0755'
  owner 'root'
  group 'root'
  notifies :run, 'execute[log-file]', :immediately
end


execute 'log-file' do
  command "sudo mysql -u root -pv < /home/ubuntu/bin-log.sql"
#  notifies :run, 'execute[grant-user]', :immediately
  action :nothing
end
