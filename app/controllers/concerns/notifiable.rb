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
      [**Feedback #{e f.id}:**](#{e base}#{e view_path}) #{e f.category}
      Submitted on [`#{e f.path}`](#{e base}#{e f.path})
      > #{e f.body}
    MSG
  end

  private

  def e(msg)
    Markdown.escape msg
  end
end
