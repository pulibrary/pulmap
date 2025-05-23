require "sneakers"
require "sneakers/handlers/maxretry"
require_relative "pulmap_config"
Sneakers.configure(
  amqp: Pulmap.config["events"]["server"],
  exchange: Pulmap.config["events"]["exchange"],
  exchange_type: :fanout,
  handler: Sneakers::Handlers::Maxretry
)
Sneakers.logger.level = Logger::INFO

WORKER_OPTIONS = {
  ack: true,
  threads: 5,
  prefetch: 10,
  timeout_job_after: 60,
  heartbeat: 5,
  amqp_heartbeat: 10,
  retry_timeout: 60 * 1000 # 60 seconds
}.freeze
