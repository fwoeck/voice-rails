$zendesk = ZendeskAPI::Client.new do |config|

  config.url      = 'https://dokmatic.zendesk.com/api/v2'
  config.username = '***REMOVED***'
  config.password = '***REMOVED***'

end
