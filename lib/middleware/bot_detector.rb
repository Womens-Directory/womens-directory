class BotDetector
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    Analytics::IgnoreVisitorJob.perform_later req.cookies["ahoy_visitor"], req.path
    @app.call(env)
  end
end
