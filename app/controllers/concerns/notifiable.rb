module Notifiable
  # this module is for Discord notifications, connects the Feedback buttons with Discord
  # concerns are methods that you can mix into your controllers that you can in multiple places
  extend ActiveSupport::Concern

  # RestClient lets you talk to another server (ex.Discord) through HTTP protocol
  # DISCORD_WEBHOOK_URL is a token that identifies who you are to the server, to give you permission to
  # talk to that server
  def notify(msg)
    body = { content: msg }
    RestClient.post ENV['DISCORD_WEBHOOK_URL'], body.to_json, {content_type: :json}
  end

  # used in other controllers
  def notify_new_feedback(feedback)
    f = feedback
    # feedback is an object in database, is a string of what a person typed in feedback
    base = request.base_url
    # base is the url that the request was at
    view_path = RailsAdmin::Engine.routes.url_helpers.show_path :feedback, f.id
    # <<~MSG (called here doc, if you need to write a long string, the quotes are MSG)
    # escape the markdown, take the feedback string and prepare as json in function above
    notify <<~MSG
      [**Feedback #{e f.id}:**](#{e base}#{e view_path}) #{e f.category}
      Submitted on [`#{e f.path}`](#{e base}#{e f.path})
      > #{e f.body}
    MSG
  end

  private

  # escapes Markdown so people can't send us malicious content through Discord
  def e(msg)
    Markdown.escape msg
  end
end
