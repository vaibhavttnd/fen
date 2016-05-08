
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
  command 'sudo apt-get -f install'
  notifies :run, 'execute[create-user]', :immediately
  action :nothing
end


execute 'create-user' do
  command "mysql -u root -pv -e\"CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'v';\""
  notifies :run, 'execute[grant-user]', :immediately
  action :nothing
end


execute 'grant-user' do
  command "mysql -u root -pv -e'GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';FLUSH PRIVILEGES;'"
  notifies :run, 'execute[xtrabackup]', :immediately
  action :nothing

end


execute 'xtrabackup' do
  command 'sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A'
  command "echo 'deb http://repo.percona.com/apt trusty main' > /etc/apt/sources.list.d/percona.list"
  command "echo 'deb-src http://repo.percona.com/apt trusty main' >> /etc/apt/sources.list.d/percona.list"
  command 'sudo apt-get update'
  command 'sudo apt-get install percona-xtrabackup'
  notifies :run, 'execute[base-backup]', :immediately
  action :nothing

end


#here rhel and debian specific home directory can be specified
execute 'base-backup' do
  command 'sudo innobackupex --no-timestamp --user=newuser  --password=v /home/ubuntu/base-backup'
  notifies :run, 'execute[incremental]', :immediately
  action :nothing
end


execute 'incremental' do
  command 'sudo innobackupex --incremental /home/ubuntu/incremental --incremental-basedir=/home/ubuntu/base-backup --user=newuser --password=v'
  action :nothing
end
