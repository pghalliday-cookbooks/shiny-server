def whyrun_supported?
  true
end

use_inline_resources

action :add do
  name = new_resource.name
  repository = new_resource.repository
  sub_folder = new_resource.sub_folder
  dependencies = new_resource.dependencies
  apps_dir = '/srv/shiny-server'
  app_link = ::File.join(apps_dir, name)
  repositories_dir = '/var/shiny-server/repositories'
  repository_dir = ::File.join(repositories_dir, name)
  if !dependencies.nil?
    dependencies.each do |dependency|
      r_package dependency
    end
  end
  if sub_folder.nil?
    app_dir = repository_dir
  else
    app_dir = ::File.join(repository_dir, sub_folder)
  end
  directory repository_dir do
    recursive true
  end
  git repository_dir do
    repository repository
  end
  link app_link do
    to app_dir
  end
end
