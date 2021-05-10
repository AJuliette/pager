module PagerService
  class MonitoredService  
    attr_accessor :healthy, :service_identifier

    def initialize(service_identifier:, healthy: true)
      @service_identifier = service_identifier
      @healthy            = healthy
    end

    def healthy?
      @healthy
    end

    def unhealthy?
      !@healthy
    end
  end
end
