class Admin::AnalyticsController < ApplicationController
	before_action :require_user!

	def index
		@reports = AnalyticsReport.all.order(updated_at: :desc)
	end

	def show
		@report = AnalyticsReport.find(params[:id])
	end

	def create
		id = Analytics.generate_report!(params[:start_date], params[:end_date])
		redirect_to admin_analytics_report_path(id), notice: "Generating report #{id} – please be patient."
	end
end
