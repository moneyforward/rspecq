require "rspec_junit_formatter"

module RSpecQ
  module Formatters
    # Junit output formatter that handles outputting of requeued examples,
    # parallel gem, and multiple suites per rspecq run.
    class JUnitFormatter < RSpecJUnitFormatter
      def initialize(queue, job, max_requeues, job_index, path)
        @queue = queue
        @job = job
        @max_requeues = max_requeues
        @requeued_examples = []
        path = path.gsub(/{{JOB_INDEX}}/, job_index.to_s)
        RSpec::Support::DirectoryMaker.mkdir_p(File.dirname(path))
        output_file = File.new(path, "w")
        super(output_file)
      end

      def example_failed(notification)
        # if it is requeued, store the notification
        if @queue.requeueable_job?(notification.example.id, @max_requeues)
          @requeued_examples << notification.example
        end
      end
    end
  end
end
