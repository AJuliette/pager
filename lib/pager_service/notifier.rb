module PagerService
  class Notifier
    def self.call(alert: , service_identifier:, alert_level:, alert_message:)
      targets = set_targets(service_identifier: service_identifier, alert_level: alert_level)
      notify_targets(targets: targets, alert_message: alert.message)
      set_timer(alert: alert)
    end

    def self.set_targets(service_identifier: service_identifier, alert_level: alert_level)
      ::PagerService::EscalationPolicyAdapter.targets(service_identifier: service_identifier, alert_level: alert_level)
    end

    def self.set_timer(alert: alert)
      ::PagerService::TimerAdapter.set(alert: alert)
    end

    def self.can_notify?(target)
      # I will describe how I would forbid the double notificiation in a Rails way:
      # I'd "lock" the target object so it could not been read when operations are made upon it
      # I'd then check if there's a recent notification made to the target
      # If it's clear, I will send the notification
      # When the object is "freed" of the lock, if there's an alert sent and dealt with at the exact same time,
      # the target could been read after the past lines already run, a recent notification would have been sent
      # So there would be no new notification
    end

    def self.notify_targets(targets:, alert_message:)
      targets.each do |target|
        if can_notify?(target)
          target[:service].notify(contact: target[:contact], message: alert_message)
        end
      end
    end
  end
end
