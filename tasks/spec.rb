begin
  gem 'rspec', '>=1.1.12'
  require 'spec'
  require 'spec/rake/spectask'
 
  task :default => [ :spec ]
 
  desc 'Run specifications'
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
    t.spec_files = Pathname.glob((ROOT + 'spec/**/*_spec.rb').to_s).map { |f| f.to_s }
  end
rescue LoadError
  # rspec not installed
end
