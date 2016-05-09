
execute 'percona_install' do
  command 'wget https://repo.percona.com/apt/percona-release_0.1-3.$(lsb_release -sc)_all.deb'
  notifies :run, 'execute[install]', :immediately
end


execute 'install' do
  command 'sudo dpkg -i percona-release_0.1-3.$(lsb_release -sc)_all.deb'
  notifies :run, 'execute[apt-update]', :immediately
  action :nothing
end



execute 'apt-update' do
  command 'sudo apt-get update'
  notifies :run, 'execute[install_percona]', :immediately
  action :nothing
end

execute 'install_percona' do
  command "echo 'percona-server-server-5.5 percona-server-server/root_password password v' | sudo debconf-set-selections"
  command "echo 'percona-server-server-5.5 percona-server-server/root_password_again password v' | sudo debconf-set-selections"
  command 'sudo apt-get install percona-server-server-5.5 -y'  
end

#user='/home/ubuntu/user.sql'

file '/home/ubuntu/user.sql' do
  content 'CREATE USER \'vaibhav\'@\'localhost\' IDENTIFIED BY \'v\';'
  mode '0755'
  owner 'root'
  group 'root'
  notifies :run, 'execute[create-user]', :immediately
end

#permission='/home/ubuntu/permission.sql'
file '/home/ubuntu/permission.sql' do
  content 'GRANT ALL PRIVILEGES ON * . * TO \'vaibhav\'@\'localhost\';FLUSH PRIVILEGES;'
  mode '0755'
  owner 'root'
  group 'root'
  notifies :run, 'execute[grant-user]', :immediately
end

file '/home/ubuntu/newdb.sql' do
  content 'CREATE DATABASE incremental;'
  mode '0755'
  owner 'root'
  group 'root'
  notifies :run, 'execute[db-create]', :immediately
end

execute 'db-create' do
  command "mysql -u root -pv < /home/ubuntu/newdb.sql"
  notifies :run, 'execute[incremental]', :immediately
  action :nothing
end


#How to notify a file ?
# passing commands as -e"<comand>" on mysql, was not working on server.

execute 'create-user' do
  command "mysql -u root -pv < /home/ubuntu/user.sql"
  action :nothing
end


execute 'grant-user' do
  command "mysql -u root -pv < /home/ubuntu/permission.sql"
  notifies :run, 'execute[xtrabackup]', :immediately
  action :nothing
end



execute 'xtrabackup' do
   command 'wget https://repo.percona.com/apt/percona-release_0.1-3.$(lsb_release -sc)_all.deb'
   notifies :run, 'execute[xtrabackup-dpkg]', :immediately
   action :nothing
end

# only one command at a time by execute ?


execute 'xtrabackup-dpkg' do
   command 'sudo dpkg -i percona-release_0.1-3.$(lsb_release -sc)_all.deb'
   notifies :run, 'execute[xtrabackup-update]', :immediately
   action :nothing
end




execute 'xtrabackup-update' do
   command 'sudo apt-get update'
   notifies :run, 'execute[xtrabackup-install]', :immediately
   action :nothing
end



execute 'xtrabackup-install' do
   command 'sudo apt-get install percona-xtrabackup -y'
   notifies :run, 'execute[base-backup]', :immediately
   action :nothing
end


#here rhel and debian specific home directory can be specified
execute 'base-backup' do
  command 'sudo innobackupex --no-timestamp --user=vaibhav  --password=v /home/ubuntu/base-backup'
  notifies :run, 'execute[db-create]', :immediately
  action :nothing
end


execute 'incremental' do
  command 'sudo innobackupex --incremental /home/ubuntu/incremental --incremental-basedir=/home/ubuntu/base-backup --user=vaibhav --password=v'
  action :nothing
end
