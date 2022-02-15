class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[ show edit update destroy ]

  # GET /student/lessons/schedule-enter
  def index

    p Tutor.first.tutor_schedules.recent(params[:select_date])

    # all Tutors
    @tutors = Tutor.all
    # today Date
    @today = Date.today
    # lesson_type =>  1: 20분 , 2 => 40분
    lesson_type = params[:lesson_type]

    # search Params hash
    search_params = Hash.new

    # if want to search tutor add tutor params to search_params
    if params[:tutor].present?
      unless params[:tutor].empty?
        search_params["tutor_id"] = params[:tutor]
      end
    end

    # if want to search date range ( a week ), add date range to search_params
    if params[:select_date].present?
      start_date = params[:select_date].to_datetime.at_beginning_of_week(start_day = :sunday)
      end_date = params[:select_date].to_datetime.at_end_of_week(start_day = :sunday)
    else
      # default date range : this week
      start_date = @today.to_datetime.at_beginning_of_week(start_day = :sunday)
      end_date = @today.to_datetime.at_end_of_week(start_day = :sunday)
    end

    # search date range
    search_params["start_time"] = start_date..end_date

    # retrieved tutor schedules data
    tutor_schedules = TutorSchedule.where(search_params)

    # response/return tutor schedule data
    @schedules = Array.new

    # response.each do |schedule|
    #   tutor_id = schedule.tutor_id
    #   schedule = schedule.as_json
    #   schedule['tutor_name'] = Tutor.find(tutor_id).name
    #   @schedules.append(schedule)
    # end

    date = start_date
    day = 0
    wday_array = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

    # process retrieved week's data
    7.times do
      minute = 0
      48.times do
        s = tutor_schedules.select {|n| n["start_time"] == date}

        if s.present?
          tutor_id = s[0].tutor_id
          # change schedule type to json
          schedule = s[0].as_json

          # if lesson_type is 40 minute
          if lesson_type == '2'
            # select next tutor schedule
            next_s = tutor_schedules.select {|n| n["start_time"] == (date + 30.minute)}

            # if lesson_type is 40 minute, check next_schedule is null
            # if next_schedule is null change current_schedule to Unavailable
            # if next_schedule exist, same tutor and next_schedule.active is Unavailanle, change current_schedule to Unavailable
            if next_s[0].nil?
              schedule['active'] = 2
            else
              if next_s[0].tutor_id == tutor_id
                if next_s[0].active == 2
                  schedule['active'] = 2
                end
              else
                schedule['active'] = 2
              end
            end
          end
          tutor_name = Tutor.find(tutor_id).name

        else
          # if select date not have tutor schedules
          # new one tutor schedule
          s = TutorSchedule.new
          s.start_time = date
          schedule = s.as_json
          if params[:tutor].present?
            tutor_name = Tutor.find(params[:tutor]).name
          else
            tutor_name = 'All'
          end
        end

        schedule['tutor_name'] = tutor_name
        schedule['date'] = date.strftime("%Y-%m-%d")
        schedule['time'] = date.strftime("%H:%M:%S")
        schedule['wday'] = wday_array[date.wday]
        @schedules.append(schedule)

        date += 30.minute
        minute += 1
      end
      day += 1
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
end