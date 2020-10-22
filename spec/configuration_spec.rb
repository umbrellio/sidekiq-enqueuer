# frozen_string_literal: true

RSpec.describe Sidekiq::Enqueuer::Configuration do
  describe "#jobs" do
    subject(:available_jobs) { config.available_jobs }

    let(:config) { described_class.new }

    context "with provided jobs" do
      before { config.jobs = %w[NoParamWorker HardWorker] }

      it { is_expected.to eq([HardWorker, NoParamWorker]) }

      context "with constants jobs" do
        before { config.jobs = [NoParamWorker, HardWorker] }

        it { is_expected.to eq([HardWorker, NoParamWorker]) }
      end

      context "with unsupported job class" do
        before { config.jobs = [123, 321] }

        it "raises corresponding error" do
          expect { available_jobs }.to raise_error(described_class::UnsupportedJobType)
        end
      end
    end

    context "without provided jobs" do
      it "queries active job and sidekiq jobs" do
        expect(available_jobs).to match_array([
          NoParamWorker, HardWorker, HardJob, WorkerWithPerformAsync, WorkerWithNoParams,
          WorkerWithKeyValueParams, WorkerWithOptionalParams, WorkerWithDefinedQueue
        ])
      end
    end
  end
end
