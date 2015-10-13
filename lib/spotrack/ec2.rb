module Spotrack
  class EC2
    AMI_REGION = "ap-northeast-1"
    AMI_TYPE = "hvm"
    COREOS_CHANNEL = "beta"
    SPOT_INSTANCE_PRODUCT_DESCRIPTIONS = ["Linux/UNIX (Amazon VPC)"]

    def initialize(client = Aws::EC2::Client.new)
      @client = client
    end

    def current_spot_instance_price(availability_zone, instance_type)
      @client.describe_spot_price_history(
        max_results: 1, product_descriptions: SPOT_INSTANCE_PRODUCT_DESCRIPTIONS, instance_types: [instance_type],
        availability_zone: availability_zone
      ).spot_price_history[0].spot_price.to_f
    end

    def describe_spot_instance_requests(request_ids)
      @client.describe_spot_instance_requests(spot_instance_request_ids: request_ids).spot_instance_requests
    end

    def request_spot_instances(availability_zone, instance_type, key_name, numbers, security_group_ids, spot_price, subnet_id)
      @client.request_spot_instances(
        request_spot_instances_option(availability_zone, instance_type, key_name, numbers, security_group_ids, spot_price, subnet_id)
      ).spot_instance_requests
    end

    private

    def ami_distributions_url(channel)
      "https://coreos.com/dist/aws/aws-#{channel}.json"
    end

    def ami_id(channel, region, type)
      JSON.parse(open(ami_distributions_url(channel)).read)[region][type]
    end

    def request_spot_instances_option(availability_zone, instance_type, key_name, numbers, security_group_ids, spot_price, subnet_id)
      {
        spot_price: spot_price.to_s, # required
        instance_count: numbers,
        type: "one-time", # accepts one-time, persistent
        availability_zone_group: availability_zone,
        launch_specification: {
          image_id: ami_id(COREOS_CHANNEL, AMI_REGION, AMI_TYPE),
          key_name: key_name,
          instance_type: instance_type,
          block_device_mappings: [
            {
              device_name: "/dev/xvda",
              ebs: {
                volume_size: 8,
                delete_on_termination: true,
                volume_type: "gp2", # accepts standard, io1, gp2
              },
            },
          ],
          subnet_id: subnet_id,
          monitoring: {
            enabled: true, # required
          },
          security_group_ids: security_group_ids,
        },
      }
    end
  end
end
