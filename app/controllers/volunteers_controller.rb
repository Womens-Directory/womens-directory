class VolunteersController < ApplicationController
  def index
  end

  def submit
    redirect_to '/', notice: "Your information was submitted and someone will contact you soon to get the process started. Thank you!"
  end
end
