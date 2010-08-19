# Install Ruby Enterprise Edition.
require_recipe "ruby_enterprise"

# Our favorite SCM,
# and an XML package for nokogiri.
%w( libxml2 libxslt1.1 git-core ).each do |pkg|
  package pkg
end

# Set up the application directory
%w( shared current ).each do |dir|
  directory "/apps/fixienews/#{dir}" do
    owner "vagrant"
    group "vagrant"
    recursive true
  end
end

# Check out the source code to the application directory
git "/apps/fixienews/current" do
  repository "git://github.com/joevandyk/fixienews.git"
  reference  "master"
  user  "vagrant"
  group "vagrant"
  action :sync
end

# Install bundler (http://gembundler.com/v1.0/index.html)
# We're using a pre-release version here.
ree_gem "bundler" do
  options "--pre"
  version "1.0.0.rc.5"
end


# Create an Upstart Service file, so we can automatically 
file "fixienews" do
  path "/etc/init/fixienews.conf"
  content <<-EOF
  start on startup
  respawn
  chdir /apps/fixienews/current
  exec su vagrant -c "./bin/unicorn"
  EOF
end

service "fixienews" do
  service_name 'fixienews'
  action :start
  provider Chef::Provider::Service::Upstart
end
