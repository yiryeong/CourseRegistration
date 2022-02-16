class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[ show destroy_reservation ]

  # GET /student/lessons/schedule-enter
  def index
    # all Tutors
    @tutors = Tutor.all
    # today Date
    @today = Date.today

    # lesson_type =>  1: 20분 , 2 => 40분
    @lesson_type = params[:lesson_type].to_i

    @selected_date  = @today
    if params[:select_date].present?
      @selected_date = params[:select_date]
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
      date = start_week(@selected_date)

      (7*48).times do
        t_schedule = tutor_schedule_list.select {|n| n["start_time"] == date}.first


        if t_schedule.present?
          # change to json
          schedule_json = t_schedule.as_json

          # if lesson_type is 40 minute, check next_schedule is null
          # if next_schedule is null, change current_schedule to Unavailable
          # if next_schedule exist, same tutor and next_schedule.active is Unavailanle, change current_schedule to Unavailable
          if @lesson_type == 2
            next_t_schedule = tutor_schedule_list.select {|n| n["start_time"] == date+30.minutes}.first
            if next_t_schedule.present?
              unless next_t_schedule.active == 1
                schedule_json['active'] = 2
              end
            else
              schedule_json['active'] = 2
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
  end

  def reservation
    reserved_schedules = User.find(current_user.id).schedules

    @reserved_schedules = Array.new
    reserved_schedules.each do |r_schedule|
      r_schedule_json = r_schedule.as_json
      r_schedule_json['tutor_name'] = r_schedule.get_tutor_name
      r_schedule_json['wday'] = r_schedule.get_wday
      r_schedule_json['date'] = r_schedule.get_date
      r_schedule_json['time'] = r_schedule.get_time
      p "d", r_schedule_json['lesson_type']
      if r_schedule_json['lesson_type'] == 1
        r_schedule_json["lesson_type_str"] = "20분"
      else
        r_schedule_json["lesson_type_str"] = "40분"
      end
      @reserved_schedules.append(r_schedule_json)
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

    @reservation_schedule = Schedule.new(schedule_params)
    @lesson_type = 1

    p "lesson type present?", params[:lesson_type].present?

    if params[:lesson_type].present?
      p "check1"
      @lesson_type = params[:lesson_type].to_i
    end

    @reservation_schedule.lesson_type = @lesson_type

    if @reservation_schedule.save

      tutor_schedule = TutorSchedule.where(tutor_id: @reservation_schedule.tutor_id, start_time: @reservation_schedule.start_time)
      tutor_schedule.update(active: 2)

      if @reservation_schedule.lesson_type == 2
        tutor_schedule = TutorSchedule.where(tutor_id: @reservation_schedule.tutor_id, start_time: @reservation_schedule.start_time + 30.minutes)
        tutor_schedule.update(active: 2)
      end

      respond_to do |format|
        format.html { redirect_to student_lessons_reservation_path(@reservation_schedule), notice: "Schedule was successfully created." }
        format.json { render :show, status: :created, location: @reservation_schedule }
      end
    end
  end

  # DELETE /student/lessons/reservation/1
  def destroy_reservation

    tutor_schedule = TutorSchedule.where(tutor_id: @reservation_schedule.tutor_id, start_time: @reservation_schedule.start_time)
    tutor_schedule.update(active: 1)

    if @reservation_schedule.lesson_type == 2
      tutor_schedule = TutorSchedule.where(tutor_id: @reservation_schedule.tutor_id, start_time: @reservation_schedule.start_time + 30.minutes)
      tutor_schedule.update(active: 1)
    end

    respond_to do |format|
      if @reservation_schedule.destroy

        format.html { redirect_to student_lessons_schedule_enter_url, notice: "schedule was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to student_lessons_schedule_enter_url:, status: :unprocessable_entity }
        format.json { render json: @reservation_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @reservation_schedule = Schedule.find(params[:id])
    end

    def start_week(selected_date)
      selected_date.to_datetime.at_beginning_of_week(start_day = :sunday)
    end

    # Only allow a list of trusted parameters through.
    def schedule_params
      params.permit(:tutor_id, :user_id, :start_time, :lesson_type)
    end
end