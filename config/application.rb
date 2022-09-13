require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ManageMovies
  class Application < Rails::Application
    config.load_defaults 7.0

    # load .env file
    if %w[development test].include? ENV['RAILS_ENV']
      Dotenv::Railtie.load
    end
  end
end
