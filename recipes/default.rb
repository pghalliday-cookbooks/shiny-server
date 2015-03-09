shiny_server_port = node['shiny-server']['port']

include_recipe 'r::default'

r_package 'shiny'
r_package 'rmarkdown'

case node['platform']
when 'ubuntu'
  include_recipe 'gdebi::default'
  deb = ::File.join(Chef::Config[:file_cache_path], 'shiny-server.deb')
  remote_file deb do
    source 'http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb'
    checksum '072d71a6039d9340da5006ea0ccd7f045f94466e5ed993e981d110c66d474273'
  end
  gdebi_package deb
when 'centos'
  rpm = ::File.join(Chef::Config[:file_cache_path], 'shiny-server.rpm')
  remote_file rpm do
    source 'http://download3.rstudio.org/centos-5.9/x86_64/shiny-server-1.3.0.403-rh5-x86_64.rpm'
    checksum '2d9006b9ce4e027ab0fb096adcc7bdcdc1800313393f725e5e8aa9c699857ca4'
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
