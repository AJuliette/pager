module PagerService
  class Alert
    attr_accessor :monitored_service, :alert_acknowledgements, :healthy_events, :level, :message

    def initialize(message:, monitored_service:)
      @message                = message
      @monitored_service      = monitored_service
      @alert_acknowledgements = []
      @healthy_events         = []
      @level                  = 0
    end

    def acknowledged?
      @alert_acknowledgements.any?
    end

    def got_healthy_event?
      @healthy_events.any?
    end

    def service_identifier
      @monitored_service.service_identifier
    end
  end
end
