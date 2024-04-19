#!/usr/bin/env ruby
# frozen_string_literal: true

#
# This file was generated by Bundler.
#
# The application 'coverage.rb' is installed as part of a gem, and
# this file is here to facilitate running it.
#

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

bundle_binstub = File.expand_path("bundle", __dir__)

if File.file?(bundle_binstub)
  if File.read(bundle_binstub, 300).include?("This file was generated by Bundler")
    load(bundle_binstub)
  else
    abort("Your `bin/bundle` was not generated by Bundler, so this binstub cannot run.
Replace `bin/bundle` by running `bundle binstubs bundler --force`, then run this command again.")
  end
end

require "rubygems"
require "bundler/setup"

load Gem.bin_path("geoblacklight", "coverage.rb")
