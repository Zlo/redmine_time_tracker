class TimeLogsController < ApplicationController
  unloadable

  menu_item :time_tracker_menu_tab_logs
  before_filter :authorize_global

  include TimeTrackersHelper

  def index
  end

  # TODO localize messages
  def add_booking
    tl = params[:time_log]
    time_log = TimeLog.where(:id => tl[:id]).first
    issue = issue_from_id(tl[:issue_id])
    time_log.add_booking(:start_time => tl[:start_time], :stop_time => tl[:stop_time], :spent_time => tl[:spent_time],
                         :comments => tl[:comments], :issue => issue, :project_id => params[:project_id_select])
    flash[:notice] = l(:success_add_booking)
  rescue BookingError => e
    flash[:error] = e.message
  ensure
    redirect_to '/tt_overview'
  end

  def show_booking
    @time_log = TimeLog.where(:id => params[:time_log_id]).first
    render :partial => 'booking_form'
  end

  def get_list_entry
    # prepare query for time_logs
    time_logs_query

    entry = TimeLog.where(:id => params[:time_log_id]).first
    render :partial => 'list_entry', :locals => {:entry => entry, :query => @query_logs, :button => :book}
  end
end