# This Capfile and deploy/* is used for ec2 deployments
load 'deploy'
require 'bundler/capistrano'

def ec2_address(input='get')
  file = 'deploy/server'
  if input == 'get'
    (File.read(file) rescue 'NO-SERVER').strip
  else
    File.open(file,'w'){|f|f.write(input)}
  end
end

set :application, "fototransporter"
set :user, "ubuntu"
set :deploy_to, "/home/#{user}/#{application}"
set :public_dir, "#{deploy_to}/current/public"

set :use_sudo, true
set :runner, "#{user}"
set :scm, :git
set :repository, "git://github.com/grosser/fotobuckit.git"
set :rails_env, "production"
set :key_pair, "mg-ec2"

# deploy to ec2
ssh_options[:keys] = "~/.ssh/ec2/#{key_pair}.pem"
server ec2_address, :app, :web, :db, :primary => true

namespace :deploy do
  task(:start){}
  task(:stop){}

  task :restart do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Copy config files to config/"
  task :copy_config_files, :roles => [:app, :db] do
    run "cp #{deploy_to}/shared/config/* #{current_release}/config/"
  end
  after 'deploy:update_code', 'deploy:copy_config_files'
end
after 'deploy', 'deploy:cleanup'

namespace :env do
  namespace :server do
    task :start do
      server = fog.servers.create(
        :image_id => 'ami-311f2b45', # ubuntu 10.04
        :flavor_id => 't1.micro',
        :key_name => key_pair
      )

      # wait for it to get online
      server.wait_for { print "."; ready? }

      puts "server started at #{server.dns_name}"
      ec2_address(server.dns_name)
    end

    task :stop do
      if server = fog.servers.detect{|s| s.dns_name == ec2_address }
        server.destroy
        ec2_address(nil)
      else
        puts "No server is running"
      end
    end
  end

  task :setup do
    run "sudo apt-get update"
    run "sudo apt-get install git-core sqlite3 libsqlite3-dev build-essential libcurl4-openssl-dev libssl-dev zlib1g-dev libreadline5-dev -y"

    # env hacks
    put "StrictHostKeyChecking no", "/home/#{user}/.ssh/config" # dont verify hosts
    put "---\ngem: --no-ri --no-rdoc", "/home/#{user}/.gemrc"

    install_ruby
    install_bundler
    install_nginx
    run "sudo /etc/init.d/nginx restart"

    # add project configuration
    run "mkdir -f #{deploy_to}/shared #{deploy_to}/shared/config #{deploy_to}/shared/pids #{deploy_to}/shared/log || echo exist"
    put File.read('config/config.yml'), "#{deploy_to}/shared/config/config.yml"
  end

  task :install_bundler do
    run "sudo gem install bundler"
  end

  task :install_nginx do
    version = '3.0.6'
    run "sudo gem install passenger -v #{version}"
    run "sudo passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx"

    config = File.read('deploy/nginx.conf') % {:passenger_version => version, :root => deploy_to}
    sudo_put config, "/opt/nginx/conf/nginx.conf"

    sudo_put File.read('deploy/nginx'), "/etc/init.d/nginx"
    run "sudo chmod +x /etc/init.d/nginx"
  end

  # ree via .deb (faster then rvm)
  task :install_ruby do
    url = 'http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise_1.8.7-2011.03_i386_ubuntu10.04.deb'
    run "which ruby || (cd /tmp && rm -rf ruby-enterprise-1.8.7*  && wget -q #{url}  && sudo dpkg -i /tmp/ruby-enterprise_*)"
  end
end

# A hacky way to put files in Capistrano with sudoer permissions
def sudo_put(data, target)
  tmp = "#{shared_path}/~tmp-#{rand(9999999)}"
  put data, tmp
  on_rollback { run "rm #{tmp}" }
  sudo "cp -f #{tmp} #{target} && rm #{tmp}"
end

def fog
  require 'fog'
  @fog ||= Fog::Compute.new(
    :provider => 'AWS',
    :region=>'eu-west-1'
  )
end
