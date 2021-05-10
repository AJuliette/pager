require_relative '../spec_helper'

describe ::PagerService::Notifier do
  let(:service_identifier) { "123456" }
  let(:monitored_service) { PagerService::MonitoredService.new(service_identifier: service_identifier) }
  let(:alert) {
    PagerService::Alert.new(
      monitored_service: monitored_service,
      message: "Danger !",
    )
  }
  let(:alert_message) { alert.message }
  let(:alert_level)   { alert.level }
  let(:targets) {
    [
      {
        service: 'MailAdapter',
        contact: "juliette@danger.com"
      },
      {
        service: 'SmsAdapter',
        contact: "+33000000"
      }
    ]
   }

  before do
    allow(PagerService::EscalationPolicyAdapter).to receive(:targets).and_return(targets)
    allow(PagerService::EscalationPolicyAdapter).to receive(:max_alert).and_return(3)
  end

  describe "call" do
    let(:subject) { described_class.call(alert: alert, service_identifier: service_identifier, alert_level: alert_level, alert_message: alert_message) }

    it "gets targets" do
      expect(::PagerService::EscalationPolicyAdapter).to receive(:targets)
      subject
    end

    it "sets timer" do
      expect(::PagerService::TimerAdapter).to receive(:set)
      subject
    end
  end
end
