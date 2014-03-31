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
    gem.add_development_dependency "ffi", ">= 0"

    if RUBY_PLATFORM !~ /java/
      gem.extensions = FileList['ext/**/extconf.rb']
      gem.extra_rdoc_files += FileList['ext/**/*.c']
    end
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/ssdeep_spec.rb', 'spec/**/*_spec.rb'].uniq
end

if RUBY_PLATFORM !~ /java/
  Rake::ExtensionTask.new("ssdeep_native")

  CLEAN.include("doc")
  CLEAN.include("rdoc")
  CLEAN.include("coverage")
  CLEAN.include("tmp")
  CLEAN.include("lib/*.bundle")
  CLEAN.include("lib/*.so")

  task :spec => :compile
end


#task :spec => :check_dependencies

task :default => :spec


