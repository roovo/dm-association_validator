require 'rubygems'
require 'pathname'

gem 'dm-core',          '>=0.9.11'
gem 'dm-validations',   '>=0.9.11'

require 'dm-core'
require 'dm-validations'

require Pathname(__FILE__).dirname.expand_path / 'dm-validations' / 'association_validator'

module DataMapper
  module ExtraValidations

    module ClassMethods
      include DataMapper::Validate::ValidatesAssociation
    end
  end
  Model.append_extensions ExtraValidations::ClassMethods
end


