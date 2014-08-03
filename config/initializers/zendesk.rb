$zendesk = ZendeskAPI::Client.new do |config|

  config.url      = "https://#{WimConfig.zendesk_domain}.zendesk.com/api/v2"
  config.username =  WimConfig.zendesk_user
  config.password =  WimConfig.zendesk_pass

  require 'logger'
  config.logger = Logger.new(STDOUT)
end
