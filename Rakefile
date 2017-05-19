require 'bundler/gem_tasks'
require 'cane/rake_task'
require 'rubocop/rake_task'

Cane::RakeTask.new(:cane) do |cane|
  cane.no_style = true
end

RuboCop::RakeTask.new(:rubocop) do |rubocop|
  rubocop.options = [
    '-c.rubocop.yml',
    '--display-cop-names'
  ]
end

task default: [:cane, :rubocop]
