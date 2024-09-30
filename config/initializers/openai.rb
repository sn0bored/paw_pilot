OpenAI.configure do |config|
  config.access_token = ENV.fetch('GPT_KEY', nil)
  config.organization_id = ENV.fetch('GPT_ORGANIZATION_ID', nil)
end