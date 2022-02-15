class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[ show edit update destroy ]

  # GET /student/lessons/schedule-enter
  def index
    # all Tutors
    @tutors = Tutor.all
    # today Date
    @today = Date.today

    # lesson_type =>  1: 20분 , 2 => 40분
    lesson_type = params[:lesson_type]

    selected_date  = @today
    if params[:select_date].present?
      selected_date = params[:select_date]
    end

    # Get Tutor List.
    tutors = @tutors
    if params[:tutor].present?
      unless params[:tutor].empty?
        tutors = [Tutor.find(params[:tutor])]
      end
    end

    # response/return tutor schedule data
    @schedules = Array.new

    tutors.each { |tutor|
      tutor_schedule_list = tutor.tutor_schedules
      reserved_schedules = tutor.schedules
      date = start_week(selected_date)

      (7*48).times do
        t_schedule = tutor_schedule_list.select {|n| n["start_time"] == date}.first

        if t_schedule.present?
          # change to json
          schedule_json = t_schedule.as_json

          # if lesson_type is 40 minute, check next_schedule is null
          # if next_schedule is null, change current_schedule to Unavailable
          # if next_schedule exist, same tutor and next_schedule.active is Unavailanle, change current_schedule to Unavailable
          if lesson_type == 2
            next_t_schedule = tutor_schedule_list.select {|n| n["start_time"] == date+30.minutes}.first
            if next_t_schedule.present?
              unless next_t_schedule.active == 1
                schedule_json['active'] = 2
              end
            end
          end
        else
          t_schedule =  TutorSchedule.new
          t_schedule.start_time = date
          schedule_json = t_schedule.as_json
        end

        schedule_json["date"] = t_schedule.get_date
        schedule_json["time"] = t_schedule.get_time
        schedule_json["wday"] = t_schedule.get_wday
        schedule_json["tutor_name"] = tutor.name
        @schedules.append(schedule_json)
        date += 30.minutes
      end
    }






    # process retrieved week's data
    # 7.times do
    #   48.times do
    #     s = tutor_schedules.select {|n| n["start_time"] == date}.first
    #
    #     if s.present?
    #       tutor_id = s.tutor_id
    #       # change to json
    #       s_json = s.as_json
    #
    #       # if lesson_type is 40 minute
    #       if lesson_type == '2'
    #         # select next tutor schedule
    #         next_s = tutor_schedules.select {|n| n["start_time"] == (date + 30.minute)}
    #
    #         # if lesson_type is 40 minute, check next_schedule is null
    #         # if next_schedule is null change current_schedule to Unavailable
    #         # if next_schedule exist, same tutor and next_schedule.active is Unavailanle, change current_schedule to Unavailable
    #
    #         # if next_s[0].nil?
    #         #   s_json["active"] = 2
    #         # else
    #         #   if next_s[0].tutor_id == tutor_id
    #         #     if next_s[0].active == 2
    #         #       s_json["active"] = 2
    #         #     end
    #         #   else
    #         #     s_json["active"] = 2
    #         #   end
    #         # end
    #       end
    #       s_json["tutor_name"] = s.get_tutor_name
    #     else
    #       # if select date not have tutor schedules
    #       # new one tutor schedule
    #       s = TutorSchedule.new
    #       s.start_time = date
    #       s_json = s.as_json
    #       s_json["tutor_name"]="All"
    #     end
    #
    #     s_json["date"] = s.get_date
    #     s_json["time"] = s.get_time
    #     s_json["wday"] = s.get_wday
    #     @schedules.append(s_json)
    #
    #     date += 30.minute
    #   end
    # end
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

      if @reserved_schedule.lesson_type == 2
        tutor_schedule = TutorSchedule.where(tutor_id: @reserved_schedule.tutor_id, start_time: @reserved_schedule.start_time + 30.minutes)
        tutor_schedule.update(active: 2)
      end

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

    def start_week(selected_date)
      selected_date.to_datetime.at_beginning_of_week(start_day = :sunday)
    end

    # Only allow a list of trusted parameters through.
    def schedule_params
      params.permit(:tutor_id, :user_id, :start_time, :lesson_type)
    end
end