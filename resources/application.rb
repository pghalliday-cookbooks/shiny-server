actions :add
default_action :add

attribute :name, name_attribute: true, kind_of: String
attribute :path, kind_of: String
attribute :dependencies, kind_of: Array
