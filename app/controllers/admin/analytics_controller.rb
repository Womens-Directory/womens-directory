class Admin::AnalyticsController < ApplicationController
	before_action :require_user!

	def index
		@reports = AnalyticsReport.all.order(created_at: :desc)
	end

	def show
		@report = AnalyticsReport.find(params[:id])
	end

	def status
		@report = AnalyticsReport.find(params[:id])
		render json: { ready: @report.ready }
	end

	def create
		id = Analytics.generate_report!(params[:start_date], params[:end_date])
		redirect_to admin_analytics_report_path(id)
	end
end
