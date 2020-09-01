# frozen_string_literal: true

require_relative 'config/application'
require 'sneakers/tasks'
require "rubocop/rake_task" if Rails.env.development? || Rails.env.test?

Rails.application.load_tasks

require 'solr_wrapper/rake_task' if Rails.env.development? || Rails.env.test?

if defined? RuboCop
  desc "Run RuboCop style checker"
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.requires << "rubocop-rspec"
    task.fail_on_error = true
  end
end
