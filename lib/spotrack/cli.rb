module Spotrack
  class CLI < Thor
    desc "current", "Show current spot instance market price"
    option :availability_zone, type: :string, desc: "Availability zone", aliases: :a
    option :instance_type, type: :string, desc: "Instance type", aliases: :i
    def current
      spot_price = current_spot_instance_price(options[:availability_zone], options[:instance_type])
      ondemand_price = current_ondemand_price(options[:instance_type])
      percentage = (spot_price.to_f / ondemand_price.to_f) * 100

      puts "Ondemand price: #{ondemand_price}"
      puts "    Spot price: #{spot_price} (#{sprintf("%.2f", percentage)}%)"
    end

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
      $stdout.sync = true

      ec2 = Spotrack::EC2.new
      request_ids = options[:spot_request_ids].split(",")

      trap("INT") do
        puts "\rExiting..."
        exit 0
      end

      puts %w(
        REQUEST_ID
        BIDDING_PRICE
        STATUS
        INSTANCE_ID
        UPDATE_TIME
        LOGGED_TIME
      ).join("\t")

      loop do
        current_time = Time.now
        requests = ec2.describe_spot_instance_requests(request_ids)

        requests.each do |request|
          puts [
            request.spot_instance_request_id,
            request.spot_price,
            request.status.code,
            request.instance_id,
            request.status.update_time,
            current_time,
          ].join("\t")
        end

        sleep 15
      end
    end

    private

    def current_spot_instance_price(availability_zone, instance_type)
      Spotrack::EC2.new.current_spot_instance_price(availability_zone, instance_type)
    end

    def current_ondemand_price(instance_type)
      Spotrack::EC2.new.current_ondemand_price(instance_type)
    end
  end
end
