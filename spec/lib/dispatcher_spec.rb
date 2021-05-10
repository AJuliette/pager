require_relative '../spec_helper'

describe ::PagerService::Dispatcher do
  let(:service_identifier) { "123456" }
  let(:monitored_service) { PagerService::MonitoredService.new(service_identifier: service_identifier) }
  let(:alert) {
    PagerService::Alert.new(
      monitored_service: monitored_service,
      message: "Danger !",
    )
   }
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

  describe "alert update" do
    let(:subject) { described_class.alert_update(alert: alert) }

    context "given a Monitored Service in a Healthy State" do
      it "turns the monitored service unhealthy" do
        subject
        expect(monitored_service.healthy?).to be_falsy
      end

      it "lets alert to first level" do
        subject
        expect(alert.level).to eq(0)
      end

      it "calls notifier" do
        expect(::PagerService::Notifier).to receive(:call)
        subject
      end
    end

    context "given a Monitored Service in a UnHealthy State" do
      let(:monitored_service) { 
        PagerService::MonitoredService.new(service_identifier: service_identifier, healthy: false) 
      }

      it "does not calls notifier" do
        expect(::PagerService::Notifier).not_to receive(:call)
        subject
      end
    end
  end

  describe "acknowledgement timeout" do
    let(:subject)     { described_class.acknowledgement_timeout_update(alert: alert) }

    context "given a Monitored Service in a UnHealthy State" do 
      let(:monitored_service) {
        PagerService::MonitoredService.new(service_identifier: service_identifier, healthy: false)
      }
      context "the corresponding Alert is not Acknowledged" do
        context "the last level has not been notified" do
          it "sets alert to next level" do
            subject
            expect(alert.level).to eq(1)
          end

          it "calls notifier" do
            expect(::PagerService::Notifier).to receive(:call)
            subject
          end
        end
      end

      context "the Pager receives a Healthy event related to this Monitored Service" do
        before do
          alert.healthy_events = [::PagerService::HealthyEvent.new(date: "Now")]
        end

        it "turns the monitored service healthy" do
          subject
          expect(monitored_service.healthy?).to be_truthy
        end

        it "does not call notifier" do
          expect(::PagerService::Notifier).not_to receive(:call)
          subject
        end
      end

      context "the Pager received the Acknowledgment" do
        before do
          alert.alert_acknowledgements = [::PagerService::HealthyEvent.new(date: "Now")]
        end

        it 'does not call notifier' do
          expect(::PagerService::Notifier).not_to receive(:call)
          subject
        end
      end
    end
  end
end
