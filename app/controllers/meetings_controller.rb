class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  def index
    @meetings = meeting_service.get_all
  end

  def create
    meeting = meeting_service.create(meeting_params)

    if meeting[:error].present?
      flash[:error] = "Error : #{meeting[:error]}"
      redirect_to action: 'index'
    else
      flash[:success] = 'Success'
      redirect_to action: 'show', id: meeting['id']
    end
  end

  private
  def meeting_params
    params.permit(:start_time, :topic, :duration, :timezone, :id, :type).to_h
  end

  def set_meeting
    @meeting = meeting_service.get_by_id(params[:id])
  end

  def meeting_service
    @service ||= Zoom::MeetingService.new
  end
end