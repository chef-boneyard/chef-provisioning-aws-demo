require 'chef_metal_aws'
with_driver 'aws'

with_datacenter 'eu-west-1' do
  # Two web servers
  (0..1).each do |i|
    machine_name = "metaldemo_web0#{i}" 

    machine machine_name do 
      action :destroy
    end
  end

  load_balancer "metaldemo-elb" do
    action :destroy
  end
end
