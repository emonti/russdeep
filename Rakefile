require 'rubygems'
require 'rake'
require 'rake/extensiontask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "russdeep"
    gem.summary = %Q{Ruby bindings for libfuzzy (from ssdeep)}
    gem.description = %Q{Ruby bindings for libfuzzy, a fuzzy hashing implementation included with the ssdeep utility}
    gem.email = "esmonti@gmail.com"
    gem.homepage = "http://github.com/emonti/russdeep"
    gem.authors = ["Eric Monti"]
    gem.add_development_dependency "rspec", ">= 1.2.9"

    gem.extensions = FileList['ext/**/extconf.rb']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

Rake::ExtensionTask.new("ssdeep_native")

CLEAN.include("lib/*.bundle")
CLEAN.include("lib/*.so")
CLEAN.include("tmp")

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "russdeep #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
