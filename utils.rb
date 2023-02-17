# Obtain or create if necessary the SWF domain used by both the workflow and
# activities code, also contain common code.

require 'aws-sdk-v1'
require 'yaml'

# Load the user's credentials from a file, if it exists.
begin
    config_file = File.open('aws-config.txt') { |f| f.read }
rescue
    puts "No config file! Hope you set your AWS credentials in the environment..."
end

if config_file.nil?
    options = { }
else
    options = YAML.load(config_file)
end

$SMS_REGION = 'ap-northeast-1'
options[:region] = $SMS_REGION

# Now, set the options
AWS.config(options)

# Registers the domain that the workflow will run in.
def init_domain
    domain_name = 'SWFDemoDomain'
    domain = nil
    swf = AWS::SimpleWorkflow.new
  
    # First, check to see if the domain already exists and is registered.
    swf.domains.registered.each do | d |
        if(d.name == domain_name)
            domain = d
            break
        end
    end
  
    if domain.nil?
      # Register the domain for one day.
      domain = swf.domains.create(
        domain_name, 1, { :description => "#{domain_name} domain" })
    end
  
    return domain
end