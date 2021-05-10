module PagerService
  class Dispatcher
    def self.alert_update(alert: alert)
      if alert.monitored_service.healthy?
        alert.monitored_service.healthy = false

        ::PagerService::Notifier.call(
          alert: alert,
          service_identifier: alert.service_identifier,
          alert_level: alert.level,
          alert_message: alert.message
        )
      end
    end

    def self.acknowledgement_timeout_update(alert: alert)
      if alert.got_healthy_event?
        alert.monitored_service.healthy = true
      elsif !alert.acknowledged?
        alert.level += 1 if alert.level <= ::PagerService::EscalationPolicyAdapter.max_alert(service_identifier: alert.service_identifier)
        
        ::PagerService::Notifier.call(
          alert: alert,
          service_identifier: alert.service_identifier,
          alert_level: alert.level,
          alert_message: alert.message
        )
      end
    end

    def self.acknowledgement_update(alert: alert)
      alert.alert_acknowledgements << ::PagerService::AlertAcknowledgement.new(date: "Now")
    end

    def healthy_event_update(alert: alert)
      alert.healthy_events << ::PagerService::HealthyEvent.new(date: "Now")
    end
  end
end
