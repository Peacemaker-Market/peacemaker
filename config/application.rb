require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Peacekeeper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_job.queue_adapter = :sidekiq

    # Support local networks
    config.hosts << IPAddr.new("0.0.0.0/0")        # All IPv4 addresses.
    config.hosts << IPAddr.new("::/0")            # All IPv6 addresses.

    # Support onion hostname
    config.hosts << begin
      File.read('hidden_service/hostname').to_s.strip
    rescue StandardError
      'test.onion'
    end
    config.hosts << ENV['APP_ONION'] if ENV['APP_ONION']
    config.hosts << ENV['APP_DOMAIN'] if ENV['APP_DOMAIN']

    if ENV['INTEGRATION_SPECS']
      config.hosts << "peer_#{ENV['INTEGRATION_SPECS']}"
    end
  end
end
