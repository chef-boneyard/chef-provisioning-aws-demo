require 'spec_helper'

describe 'java::oracle_rpm' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'redhat', version: '6.5') do |node|
      node.automatic['java']['install_flavor'] = 'oracle_rpm'
    end.converge(described_recipe)
  end

  it 'includes the set_java_home recipe' do
    expect(chef_run).to include_recipe('java::set_java_home')
  end

  describe 'update-java-alternatives' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: platform, version: version) do |node|
        node.automatic['java']['install_flavor'] = 'oracle_rpm'
        node.set['java']['set_default'] = true
      end.converge(described_recipe)
    end

    describe 'for RHEL' do
      let(:platform) { 'redhat' }
      let(:version) { '6.5' }

      it 'does not run bash command' do
        expect(chef_run).not_to run_bash('update-java-alternatives')
      end
    end
  end

  describe 'package_name attribute' do
    describe 'using default value' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.automatic['java']['install_flavor'] = 'oracle_rpm'
        end.converge(described_recipe)
      end

      it 'does not install package_name' do
        expect(chef_run).not_to install_package('')
      end
    end

    context 'when package_name is set' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.automatic['java']['install_flavor'] = 'oracle_rpm'
          node.set['java']['oracle_rpm']['package_name'] = 'prime-caffeine'
        end.converge(described_recipe)
      end

      it 'installs package_name' do
        expect(chef_run).to install_package('prime-caffeine')
      end
    end

    context 'when package_name and package_version is set' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.automatic['java']['install_flavor'] = 'oracle_rpm'
          node.set['java']['oracle_rpm']['package_name'] = 'prime-caffeine'
          node.set['java']['oracle_rpm']['package_version'] = '8.7.6-goldmaster'
        end.converge(described_recipe)
      end

      it 'installs package_name with specific version' do
        expect(chef_run).to install_package('prime-caffeine').with(
          version: '8.7.6-goldmaster'
        )
      end
    end

    context 'when type is set' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.automatic['java']['install_flavor'] = 'oracle_rpm'
          node.set['java']['oracle_rpm']['type'] = 'jdk'
        end.converge(described_recipe)
      end

      it 'installs type' do
        expect(chef_run).to install_package('jdk')
      end
    end

    context 'when package_name and type are set' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.automatic['java']['install_flavor'] = 'oracle_rpm'
          node.set['java']['oracle_rpm']['package_name'] = 'top-shelf-beans'
          node.set['java']['oracle_rpm']['type'] = 'jdk'
        end.converge(described_recipe)
      end

      it 'installs package_name instead of type' do
        expect(chef_run).to install_package('top-shelf-beans')
      end
    end
  end

  describe 'type attribute' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.automatic['java']['install_flavor'] = 'oracle_rpm'
        node.set['java']['oracle_rpm']['type'] = type
      end.converge(described_recipe)
    end

    describe 'using default value' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.automatic['java']['install_flavor'] = 'oracle_rpm'
        end.converge(described_recipe)
      end

      it 'installs jdk package' do
        expect(chef_run).to install_package('jdk')
      end
    end

    describe 'for valid values' do
      shared_examples 'expected java packages are installed' do
        it "installs package" do
          expect(chef_run).to install_package(type)
        end

        it 'does not raise an error' do
          expect { chef_run }.not_to raise_error
        end
      end

      context 'for jdk' do
        let(:type) { 'jdk' }

        it_behaves_like 'expected java packages are installed'
      end

      context 'for jre' do
        let(:type) { 'jre' }

        it_behaves_like 'expected java packages are installed'
      end
    end

    describe 'for invalid values' do
      let(:type) { 'banana' }

      it 'raises an error' do
        expect { chef_run }.to raise_error
      end
    end
  end
end
