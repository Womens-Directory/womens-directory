class BotDetector
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    ignore_visitor_if_bot req.cookies["ahoy_visitor"], req.path # TODO: hot path, job this?
    @app.call(env)
  end
end
