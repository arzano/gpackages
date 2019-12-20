class CommitsUpdateJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Portage::Util::History.update
  end
end
