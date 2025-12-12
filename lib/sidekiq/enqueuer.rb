# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/enqueuer/configuration"
require "sidekiq/enqueuer/utils"
require "sidekiq/enqueuer/version"
require "sidekiq/enqueuer/worker/instance"
require "sidekiq/enqueuer/worker/param"
require "sidekiq/enqueuer/worker/trigger"
require "sidekiq/enqueuer/web_extension/helper"
require "sidekiq/enqueuer/web_extension/loader"
require "sidekiq/enqueuer/web_extension/params_parser"

module Sidekiq
  module Enqueuer
    SIDEKIQ_GTE_8 = Gem::Version.new(Sidekiq::VERSION) >= Gem::Version.new("8.0.0")

    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end

      def jobs
        configuration.available_jobs.map do |job|
          Worker::Instance.new(job, async: configuration.async)
        end
      end
    end
  end
end

if defined?(Sidekiq::Web)
  locales_path = File.join(File.dirname(__FILE__), "enqueuer/locales")

  if Sidekiq::Enqueuer::SIDEKIQ_GTE_8
    # Sidekiq 8+ uses Web.configure with keyword arguments
    Sidekiq::Web.configure do |config|
      config.register(
        Sidekiq::Enqueuer::WebExtension::Loader,
        name: "enqueuer",
        tab: "Enqueuer",
        index: "enqueuer"
      )
    end
    Sidekiq::Web.locales << locales_path
  else
    # Sidekiq 7 and earlier
    Sidekiq::Web.register(Sidekiq::Enqueuer::WebExtension::Loader)
    Sidekiq::Web.tabs["Enqueuer"] = "enqueuer"
    Sidekiq::Web.settings.locales << locales_path
  end
end
