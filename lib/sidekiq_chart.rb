# frozen_string_literal: true

require 'sidekiq/api'

class SidekiqChart
  def render
    chart = ""
    sidekiq_data.each_key do |k|
      chart += build_chart_line(k)
    end

    chart
  end

  private

  def build_chart_line(job_type)
    length = sidekiq_data[job_type] / scale
    line = job_type.to_s.rjust(10)
    line << "  #{sidekiq_data[job_type]}".rjust(7)
    line << "      #{chart_bar(length)}"
    line << "\n"
    line << "\n"
    line
  end

  def chart_bar(length)
    "\e[44m \e[0m" * length
  end

  def dead_set
    Sidekiq::DeadSet.new
  end

  def retry_set
    Sidekiq::RetrySet.new
  end

  def scale
    max_bar_length = 100.0
    value = sidekiq_data.values.max / max_bar_length

    # return 1 instead of 0.0 to avoid a NaN error
    value == 0.0 ? 1 : value
  end

  def sidekiq_data
    {
      Busy: workers.size,
      Enqueued: stats.enqueued,
      Processed: stats.processed,
      Failed: stats.failed,
      Retries: retry_set.size,
      Dead: dead_set.size
    }
  end

  def stats
    Sidekiq::Stats.new
  end

  def workers
    Sidekiq::Workers.new
  end
end
