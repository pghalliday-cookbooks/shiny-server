shiny_server_port = node['shiny-server']['port']

include_recipe 'r::default'

r_package 'shiny'
r_package 'rmarkdown'

case node['platform']
when 'ubuntu'
  include_recipe 'gdebi::default'
  deb = ::File.join(Chef::Config[:file_cache_path], 'shiny-server.deb')
  url = node['shiny-server']['ubuntu']['deb']
  checksum = node['shiny-server']['ubuntu']['checksum']
  remote_file deb do
    source url
    checksum checksum
  end
  gdebi_package deb
when 'centos'
  rpm = ::File.join(Chef::Config[:file_cache_path], 'shiny-server.rpm')
  url = node['shiny-server']['centos']['rpm']
  checksum = node['shiny-server']['centos']['checksum']
  remote_file rpm do
    source url
    checksum checksum
    notifies :run, 'bash[install shiny server]', :immediately
  end
  # using the standard package resource fails
  # with no candidate version error which is strange
  bash 'install shiny server' do
    code <<-EOH
      yum install --nogpgcheck -y #{rpm}
      EOH
    action :nothing
  end
end

template '/etc/shiny-server/shiny-server.conf' do
  source 'shiny-server.conf.erb'
  variables(
    port: shiny_server_port
  )
  notifies :restart, 'service[shiny-server]', :delayed
end

service 'shiny-server' do
  supports status: true, restart: true, reload: true
  provider Chef::Provider::Service::Upstart
end
