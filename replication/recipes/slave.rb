

execute 'copy' do
 command 'cp -a /home/ubuntu/base/. /var/lib/mysql/'
 notifies :run, 'execute[install]', :immediately
 action :nothing
end


execute 'master' do
#add ip
 command 'mysql --host= --user=repl --password=v'
 notifies :run, 'execute[install]', :immediately
 action :nothing
end


#check te spacing in my.cnf of server-id
execute 'sed' do
#add ip
 command "sed -i 's/server-id=1/server-id=2/' /etc/mysql/my.cnf"
 notifies :run, 'execute[install]', :immediately
 action :nothing
end

