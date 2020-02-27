# frozen_string_literal: true

namespace :sidekiq do
  desc 'Show sidekiq stats'
  task stats: :environment do
    chart_builder = SidekiqChart.new
    loop do
      chart = chart_builder.render
      puts "\e[H\e[2J"
      puts chart
      sleep 5
    rescue Interrupt
      break
    end
  end
  desc 'Clear queues'
  task clear_queues: :environment do
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
    Sidekiq::DeadSet.new.clear
  end
  desc 'Clear stats'
  task clear_stats: :environment do
    Sidekiq::Stats.new.reset
  end
end
