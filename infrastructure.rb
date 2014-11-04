require 'chef/provisioning/aws_driver'
with_driver 'aws'

with_data_center 'eu-west-1' do
  machine_names = []

  # Two web servers
  (0..1).each do |i|
    machine_name = "metaldemo_web0#{i}" 
    machine_names << machine_name

    machine machine_name do 
      machine_options :bootstrap_options => {
            :key_name => 'chef_key'
      }
      attribute 'java', {
        'install_flavor' => 'oracle', 
        'jdk_version' => '8',
        'oracle' => {
          'accept_oracle_download_terms' => true
        }
      }
      attribute 'apt', { 
        'compile_time_update' => true
      }
      recipe 'apt'
      recipe 'supervisor'
      recipe 'java'
      recipe 'simpleserver'
    end
  end

  load_balancer "metaldemo-elb" do
    load_balancer_options :availability_zones => ['eu-west-1a', 'eu-west-1b', 'eu-west-1c'],
                          :listeners => [{
                               :port => 80,
                               :protocol => :http,
                               :instance_port => 8080,
                               :instance_protocol => :http,
                           }]
    machines machine_names
  end
end
