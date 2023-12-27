class BotDetector
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    rule = matching_rule(req.path)
    if rule
      vi = VisitorIgnore.find_or_initialize_by visitor_token: req.cookies["ahoy_visitor"]
      if vi.new_record?
        vi.visitor_ignore_rule = rule
        vi.save!
      end
    end
    @app.call(env)
  end

  private

  def rules
    Rails.cache.fetch("visitor_ignore_rules", expires_in: 5.minutes) { VisitorIgnoreRule.all }
  end

  def matching_rule(path)
    rules.find { |r| path.match?(Regexp.new(r.pattern)) }
  end
end
