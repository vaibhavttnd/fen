


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


#here rhel and debian specific home directory can be specified
execute 'base-backup' do
  command 'innobackupex --no-timestamp --user=newuser  --password=v /home/ubuntu/base-backup'
end
