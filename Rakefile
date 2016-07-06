require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require 'rspec/core/rake_task'

task default: :ci

unless Rails.env == 'production'
  require 'rubocop/rake_task'

  desc 'Run style checker'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.fail_on_error = true
  end
end

desc 'Run test suite and style checker'
task spec: :rubocop do
  RSpec::Core::RakeTask.new(:spec)
end
