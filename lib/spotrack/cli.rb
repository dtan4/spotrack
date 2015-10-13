module Spotrack
  class CLI < Thor
    desc "request", "Request spot instance(s)"
    option :availability_zone, type: :string, desc: "Availability zone", aliases: :a
    option :instance_type, type: :string, desc: "Instance type", aliases: :i
    option :key_name, type: :string, desc: "The name of SSH key pair", aliases: :k
    option :magnification, type: :numeric, desc: "The magnification of bidding price against current price", aliases: :m, default: 1.2
    option :numbers, type: :numeric, desc: "The number of instances", aliases: :n, default: 1
    option :security_group_ids, type: :string, desc: "List of security groups", aliases: :g
    option :spot_price, type: :numeric, desc: "The bidding price", aliases: :p
    option :subnet_id, type: :string, desc: "The ID of subnets", aliases: :b
    def request
      spot_price = if options[:spot_price]
                     options[:spot_price]
                   else
                     current_spot_instance_price(options[:availability_zone], options[:instance_type]) * options[:magnification]
                   end

      puts Spotrack::EC2.new.request_spot_instances(
        options[:availability_zone], options[:instance_type], options[:key_name], options[:numbers],
        options[:security_group_ids].split(","), spot_price, options[:subnet_id]
      ).map { |request| request.spot_instance_request_id }.join(",")
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

    private

    def current_spot_instance_price(availability_zone, instance_type)
      Spotrack::EC2.
new.current_spot_instance_price(availability_zone, instance_type)
    end
  end
end
