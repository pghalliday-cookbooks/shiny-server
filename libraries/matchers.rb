if defined?(ChefSpec)
  def add_shiny_server_application(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:shiny_server_application, :add, resource_name)
  end
end
