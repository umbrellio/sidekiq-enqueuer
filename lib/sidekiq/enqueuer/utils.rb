# frozen_string_literal: true

module Sidekiq
  module Enqueuer
    module Utils
      extend self

      def active_job?(job_class)
        return false if job_class.singleton_class?

        job_class < ::ActiveJob::Base
      end

      def sidekiq_job?(job_class)
        job_class.included_modules.include?(::Sidekiq::Worker) && job_class.instance_methods.any? { |method| method.start_with?("perform") }
      end
    end
  end
end
