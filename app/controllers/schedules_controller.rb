class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[ show edit update destroy ]

  # GET /student/lessons/schedule-enter
  def index
    @tutors = Tutor.all
    @today = Date.today
    lessons_type = params[:lesson_type]

    search_params = Hash.new

    if params[:tutor].present?
      unless params[:tutor].empty?
        search_params["tutor_id"] = params[:tutor]
      end
    end

    start_date = params[:select_date].to_datetime.at_beginning_of_week(start_day = :sunday)
    end_date = params[:select_date].to_datetime.at_end_of_week(start_day = :sunday)
    search_params["start_time"] = start_date..end_date

    tutor_schedules = TutorSchedule.where(search_params)

    @schedules = Array.new

    # response.each do |schedule|
    #   tutor_id = schedule.tutor_id
    #   schedule = schedule.as_json
    #   schedule['tutor_name'] = Tutor.find(tutor_id).name
    #   @schedules.append(schedule)
    # end

    date = start_date
    day = 0
    while day < 7
      minute = 0
      while minute < 48
        s = tutor_schedules.select {|n| n["start_time"] == date}

        if s.present?
          tutor_id = s[0].tutor_id
          schedule = s[0].as_json
          schedule['tutor_name'] = Tutor.find(tutor_id).name
        else
          s = TutorSchedule.new
          s.start_time = date
          schedule = s.as_json
          if params[:tutor].present?
            schedule['tutor_name'] = Tutor.find(params[:tutor]).name
          end
        end
        @schedules.append(schedule)

        date += 30.minute
        minute += 1
      end
      day += 1
    end

    end

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
      tutor_schedule = TutorSchedule.where(tutor_id: @reserved_schedule.tutor_id, start_time: @reserved_schedule.start_time)
      tutor_schedule.update(active: 2)
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
