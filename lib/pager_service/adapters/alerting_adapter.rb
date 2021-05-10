module PagerService
  class AlertingAdapter
    def self.notify(service_identifier:, alert_message:)
      ## Sends the alert:
      # PagerService::Dispatcher.alert_update(
      #  alert: PagerService::Alert.new(
      #    monitored_service: monitored_service,
      #    alert_message: 'Danger !',
      #  )
      # )
    end
  end
end
