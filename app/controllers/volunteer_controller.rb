class VolunteerController < ApplicationController
  def show
  end

  def submit
    name = params['name']
    contact = params['contact']
    hours = params['hours']
    why = params['why']
    send_to_discord(name, contact, hours, why)
  end

  private

  def send_to_discord(name, contact, hours, why)
    msg = <<~MSG
      Volunteer info:
      #{e name}
      #{e contact}
      #{e hours} hours per week
      #{e why}
    MSG
    body = {content: msg}.to_json
    RestClient.post ENV['DISCORD_VOLUNTEER_WEBHOOK_URL'], body, {content_type: :json}
  end

  def e(msg)
    Markdown.escape msg
  end
end
