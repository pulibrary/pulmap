require 'sneakers'
require_relative 'pulmap_config'
Sneakers.configure(
  amqp: Pulmap.config["events"]["server"],
  exchange: Pulmap.config["events"]["exchange"],
  exchange_type: :fanout,
  daemonize: true
)
Sneakers.logger.level = Logger::INFO
