def whyrun_supported?
  true
end

use_inline_resources

action :add do
  name = new_resource.name
  path = new_resource.path
  dependencies = new_resource.dependencies
  apps_dir = '/srv/shiny-server'
  app_link = ::File.join(apps_dir, name)
  if !dependencies.nil?
    dependencies.each do |dependency|
      r_package dependency
    end
  end
  link app_link do
    to path
  end
end
