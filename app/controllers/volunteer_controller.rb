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
    puts msg
  end

  def e(msg)
    Markdown.escape msg
  end
end
