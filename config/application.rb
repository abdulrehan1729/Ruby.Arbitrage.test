require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Test
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.active_job.queue_adapter = :sidekiq
    config.load_defaults 5.2
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache'
    config.cache_store = :redis_cache_store, {url: "redis://192.168.0.10:6379/0"}
  
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
