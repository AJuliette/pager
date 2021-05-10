module PagerService
  class ConsoleAdapter
    def self.notify_healthy_event(dispatcher: dispatcher)
      ## Sends the alert:
      # dispatcher.healthy_event_update
    end

    def self.notify_acknowledgement(dispatcher: dispatcher)
      ## Sends the alert:
      # dispatcher.acknowledgement_update
    end
  end
end
