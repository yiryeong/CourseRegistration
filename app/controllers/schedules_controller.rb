class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[ show edit update destroy ]

  # GET /student/lessons/schedule-enter
  def index
    @tutors = Tutor.all
    @tutor_schedules = TutorSchedule.all
    @today = Date.today

    if params[:lesson_type].present?
      @lessons_type = params[:lesson_type]
    end
    if params[:tutor].present?
      @tutor_id = params[:tutor]
      @tutor_name = Tutor.find(@tutor_id).name
      @schedules = TutorSchedule.where(tutor_id: params[:tutor])
    end
    if params[:select_datetime].present?
      # @schedules = TutorSchedule.where("start_time >= ?": Date.today.at_beginning_of_week))
      @schedules = TutorSchedule.where("start_time >= :start_date AND start_time <= :end_date",
            {:start_date => @today.at_beginning_of_week, :end_date =>@today.at_end_of_week})

      # @schedules.each_with_index { |schedule, i|
      #   tutor = Tutor.find(schedule[:tutor_id])
      #   schedule.tutor_name = tutor.name
      #   # schedule.store(:tutor_name, tutor.name)
      #   puts(schedule)
      # }
    end

    # TutorSchedule.where("start_time >= :start_date AND start_time <= :end_date",
    #   {:start_date => Date.today.at_beginning_of_week, :end_date => Date.today.at_end_of_week})
    #   {:start_date => params[:select_datetime].at_beginning_of_week, :end_date => Date.today.at_end_of_week})
    # @reserved_schedules = Schedule.where(user_id: session[:user_id])
  end

  # GET /student/lessons/schedule-enter/1
  def show
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
    # @tutor_schedule = TutorSchedule.where(tutor_id: schedule.tutor_id, start_time: schedule.start_time)
    # @tutor_schedule.update(active: 2)
    # redirect_to student_lessons_schedule_enter_url(@reserved_schedule), notice: "Schedule was successfully created."

    @reserved_schedule = Schedule.new(schedule_params)

    if @reserved_schedule.save
      @tutor_schedule = TutorSchedule.where(tutor_id: @reserved_schedule.tutor_id, start_time: @reserved_schedule.start_time)
      @tutor_schedule.update(active: 2)
      respond_to do |format|
        format.html { redirect_to student_lessons_schedule_enter_url(@reserved_schedule), notice: "Schedule was successfully created." }
        format.json { render :show, status: :created, location: @reserved_schedule }
      end
    else
      respond_to do |format|
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
      params.permit(:tutor_id, :user_id, :start_time, :lesson_type)
    end
end
