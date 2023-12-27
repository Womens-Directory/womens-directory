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
		start_date = params[:start_date]
		end_date = params[:end_date]
		tz_offset = params[:tz_offset]

		start_date = Time.parse(start_date + ' UTC') + tz_offset.to_i.minutes
		end_date = Time.parse(end_date + ' UTC') + tz_offset.to_i.minutes

		id = Analytics.generate_report!(start_date, end_date)
		redirect_to admin_analytics_report_path(id)
	end
end
