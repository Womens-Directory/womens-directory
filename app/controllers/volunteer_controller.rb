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
    url = 'https://discord.com/api/webhooks/911800531234734111/IVegDQ5UdFmJ4k0WagwTiSaLOGdQuoGxYv2-hpcsCgPS7I9uzmbF2K2z3z4KDI5B6kdR'
    body = {content: msg}.to_json
    RestClient.post url, body, {content_type: :json}
  end

  def e(msg)
    Markdown.escape msg
  end
end
