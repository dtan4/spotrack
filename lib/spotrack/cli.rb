module Spotrack
  class CLI < Thor
    desc "request", "Request spot instance(s)"
    option :instance_type, type: :string, desc: "Instance type", aliases: :i, default: "c4.xlarge"
    option :numbers, type: :numeric, desc: "The number of instances", aliases: :n, default: 1
    def request

    end

    desc "watch", "Watch spot requests"
    option :spot_request_ids, type: :string, desc: "List of IDs of spot requests", aliases: :s, required: true
    def watch
      request_ids = options[:spot_request_ids].split(",")

      trap("INT") do
        puts "\rExiting..."
        exit 0
      end

      loop do
        sleep 30
      end
    end
  end
end
