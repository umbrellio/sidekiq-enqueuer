# frozen_string_literal: true

module Sidekiq
  module Enqueuer
    module WebExtension
      module Helper
        def get_params_by_action(name, job)
          param_value = if Sidekiq::Enqueuer::SIDEKIQ_GTE_8
            url_params(name)
          else
            params[name]
          end

          return [] if param_value.nil?

          Sidekiq::Enqueuer::WebExtension::ParamsParser.new(param_value, job).process
        end

        def find_job_by_class_name(job_class_name)
          Sidekiq::Enqueuer.jobs.find do |job_klass|
            job_klass.job == job_class_name ||
              job_klass.job.to_s == job_class_name ||
              job_klass.name == job_class_name
          end
        end
      end
    end
  end
end
