require 'pathname'
require 'rubygems'
require 'rake'
require 'echoe'

ROOT = Pathname(__FILE__).dirname.expand_path

Echoe.new('dm-association_validator') do |p|
  p.description               = "A validator for use with associated models"
  p.url                       = "http://github.com/roovo/dm-association_validator"
  p.author                    = "roovo"
  p.email                     = "roovo@roovoweb.com"
  p.ignore_pattern            = ["tmp/*", "script/*"]
  p.development_dependencies  = []
  p.runtime_dependencies      = ['dm-core', 'dm-validations']
end

Pathname.glob(ROOT.join('tasks/**/*.rb').to_s).each { |f| require f }
