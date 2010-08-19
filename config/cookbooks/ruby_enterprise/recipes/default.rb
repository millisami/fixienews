%w{ libssl-dev libreadline5-dev }.each do |pkg|
  package pkg
end

remote_file "/root/ruby-enterprise.dpkg" do
  source   node[:ruby_enterprise][:dpkg_url]
  checksum node[:ruby_enterprise][:dpkg_sha]
end

dpkg_package "ruby-enterprise" do
  source "/root/ruby-enterprise.dpkg"
end
