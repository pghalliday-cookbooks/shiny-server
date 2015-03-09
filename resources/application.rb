actions :add
default_action :add

attribute :name, name_attribute: true, kind_of: String
attribute :repository, kind_of: String
attribute :sub_folder, kind_of: String
attribute :dependencies, kind_of: Array
