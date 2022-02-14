class SchedulesController < ApplicationController
  # before_action :set_schedule, only: %i[ show edit update destroy ]

  # GET /student/lessons/schedule-enter
  def index
    @tutors = Tutor.all
    @tutor_schedules = TutorSchedule.all
    @today = Date.today

    if params.has_key?(:mode)
      @mode = params[:mode]
    end
    if params[:lesson_type].present?
      @lessons_type = params[:lesson_type]
    end
    if params[:tutor].present?
      @tutor_id = params[:tutor]
      @tutor_name = Tutor.find(@tutor_id).name
      @schedules = TutorSchedule.where(tutor_id: params[:tutor])
    end
  end

  # GET /student/lessons/schedule-enter/new
  def new
    @reserved_schedule = Schedule.new
  end

  # POST /student/lessons/schedule-enter
  def create
    # schedule = Schedule.new
    # schedule.user_id = params[:user_id]
    # schedule.tutor_id = params[:tutor_id]
    # schedule.start_time = params[:start_time]
    # schedule.lesson_type = params[:lesson_type]
    # schedule.save
    @reserved_schedule = Schedule.new(schedule_params)

    respond_to do |format|
      if @reserved_schedule.save
        format.html { redirect_to student_lessons_schedule_enter_url(@reserved_schedule), notice: "Schedule was successfully created." }
        format.json { render :show, status: :created, location: @reserved_schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reserved_schedule.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @reserved_schedule = Schedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def schedule_params
      params.require(:schedule).permit(:tutor_id, :user_id, :start_time, :lesson_type)
    end
end
