module Notifiable
  extend ActiveSupport::Concern

  def notify(msg)
    body = { content: msg }
    RestClient.post ENV['DISCORD_WEBHOOK_URL'], body.to_json, {content_type: :json}
  end

  def notify_new_feedback(feedback)
    f = feedback
    base = request.base_url
    view_path = RailsAdmin::Engine.routes.url_helpers.show_path :feedback, f.id
    notify <<~MSG
      [**Feedback #{f.id}:**](#{base}#{view_path}) #{f.category}
      Submitted on [`#{f.path}`](#{base}#{f.path})
      > #{f.body}
    MSG
  end
end
