# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.name        = "pivotable"
  s.summary     = "Build pivotable data tables with ActiveRecord"
  s.description = "Great for building APIs & reports"
  s.version     = '0.0.3'

  s.authors     = ["Dimitrij Denissenko"]
  s.email       = "dimitrij@blacksquaremedia.com"
  s.homepage    = "https://github.com/bsm/pivotable"

  s.require_path = 'lib'
  s.files        = Dir['LICENSE', 'README.markdown', 'lib/**/*']

  s.add_dependency "abstract"
  s.add_dependency "activerecord", "~> 3.0.0"
  s.add_dependency "activesupport", "~> 3.0.0"
end
