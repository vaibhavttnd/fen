


execute 'percona_install' do
  command 'wget https://repo.percona.com/apt/percona-release_0.1-3.$(lsb_release -sc)_all.deb'
  command 'dpkg -i percona-release_0.1-3.$(lsb_release -sc)_all.deb'
end

execute 'apt-update' do
  command 'sudo apt-get update'
end


execute 'apt-update' do
  command 'apt-get install percona-server-server-5.5'
end


execute 'create-user' do
  command '/usr/bin/mysql -u root -pv -e"CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'v';"'
end


execute 'grant-user' do
  command '/usr/bin/mysql -u root -pv -e"GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';FLUSH PRIVILEGES;"'
end


execute 'xtrabackup' do
  command 'sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A'
  command "sudo sh -c "echo 'deb http://repo.percona.com/apt trusty main' > /etc/apt/sources.list.d/percona.list""
  command "sudo sh -c "echo 'deb-src http://repo.percona.com/apt trusty main' >> /etc/apt/sources.list.d/percona.list""
  command 'sudo apt-get update'
  command 'sudo apt-get install percona-xtrabackup'
end


#here rhel and debian specific home directory can be specified
execute 'base-backup' do
  command 'innobackupex --no-timestamp --user=newuser  --password=v /home/ubuntu/base-backup'
end


execute 'incremental' do
  command 'innobackupex --incremental /home/ubuntu/incremental --incremental-basedir=/home/ubuntu/base-backup --user=newuser --password=v'
end


