environment_hash = {  
  "HOME" => "/tmp"
}

cookbook_file 'simplehttpserver-1.0-SNAPSHOT.jar' do 
  path "/tmp/simpleserver.jar"
  action :create
end

supervisor_service "simpleserver" do
  action                  :enable
  autostart               true
  user                    "nobody"
  command                 "java -jar /tmp/simpleserver.jar"
  stdout_logfile          "/tmp/simpleserver-stdout.log"
  stdout_logfile_backups  10
  stdout_logfile_maxbytes "50MB"
  stdout_capture_maxbytes "0"
  stderr_logfile          "/tmp/simpleserver-stderr.log"
  stderr_logfile_backups  10
  stderr_logfile_maxbytes "50MB"
  stderr_capture_maxbytes "0"
  directory               "/tmp"
  environment             environment_hash
end
