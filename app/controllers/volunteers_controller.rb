class VolunteersController < ApplicationController
  def index
    @volunteers = Volunteer.all
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(params.require(:volunteer).permit(:first_name, :last_name, :hours_per_week, :phone, :email))

    respond_to do |format|
      if @volunteer.save
        format.html { redirect_to @volunteer, notice: "You have submitted the information below." }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @volunteer = Volunteer.find(params[:id])
  end

  def update
    @volunteer = Volunteer.find(params[:id])
    respond_to do |format|
      if @volunteer.update(params.require(:volunteer).permit(:first_name, :last_name, :email, :phone, :hours_per_week))
        format.html { redirect_to volunteers, notice: "The record was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end

  def show
    @volunteer = Volunteer.find(params[:id])
  end

  def destroy
    @volunteer = Volunteer.find(params[:id])
    @volunteer.destroy

    respond_to do |format|
      format.html { redirect_to volunteers_url, notice: "Record was removed." }
    end
  end
end
