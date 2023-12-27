class BotDetector
  def initialize(app, regex_patterns)
    @app = app
    @regex_patterns = regex_patterns
  end

  def call(env)
    req = Rack::Request.new(env)
    if match_regex?(req.path)
      ap "bot detected: #{req.path}"
    end
    @app.call(env)
  end

  private

  def match_regex?(path)
    @regex_patterns.any? { |pattern| path =~ pattern }
  end
end
