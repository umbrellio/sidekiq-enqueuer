# frozen_string_literal: true

module Sidekiq
  module Enqueuer
    module WebExtension
      module Loader
        def self.registered(app)
          view_path = File.join(File.expand_path("../..", __FILE__), "views")
          app.helpers(WebExtension::Helper)

          app.get "/enqueuer" do
            @jobs = Sidekiq::Enqueuer.jobs
            render(:erb, File.read(File.join(view_path, "index.erb")))
          end

          app.get "/enqueuer/:job_class_name" do
            job_class_name = if Sidekiq::Enqueuer::SIDEKIQ_GTE_8
              route_params(:job_class_name)
            else
              params[:job_class_name]
            end
            @job = find_job_by_class_name(job_class_name)
            render(:erb, File.read(File.join(view_path, "new.erb")))
          end

          app.post "/enqueuer" do
            job_class_name = if Sidekiq::Enqueuer::SIDEKIQ_GTE_8
              url_params("job_class_name")
            else
              params[:job_class_name]
            end
            job = find_job_by_class_name(job_class_name)

            if job.present?
              requested_params = get_params_by_action("perform", job)

              submit_action = if Sidekiq::Enqueuer::SIDEKIQ_GTE_8
                url_params("submit")
              else
                params["submit"]
              end

              case submit_action
              when "Enqueue"
                job.trigger(requested_params)
              when "Schedule"
                enqueue_in = if Sidekiq::Enqueuer::SIDEKIQ_GTE_8
                  url_params("enqueue_in")
                else
                  params["enqueue_in"]
                end
                job.trigger_in(enqueue_in, requested_params)
              end
            end

            redirect(File.join(root_path, "enqueuer"))
          end
        end
      end
    end
  end
end
