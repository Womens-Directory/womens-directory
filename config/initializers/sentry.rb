Sentry.init do |config|
  config.dsn = 'https://d8b25a2af764474fb35a7cde27e2c53c@o4504147777224704.ingest.sentry.io/4504147815366656'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 1.0
end
