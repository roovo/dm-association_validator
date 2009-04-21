require 'pathname'
require 'rubygems'
require 'rake'

ROOT = Pathname(__FILE__).dirname.expand_path

Pathname.glob(ROOT.join('tasks/**/*.rb').to_s).each { |f| require f }
