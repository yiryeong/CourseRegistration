class TutorSchedulesController < ApplicationController
  before_action :set_tutor_schedule, only: %i[ show edit update destroy ]

  # GET /tutor_schedules or /tutor_schedules.json
  def index
    @tutor_schedules = TutorSchedule.all
  end

  # GET /tutor_schedules/1 or /tutor_schedules/1.json
  def show
  end

  # GET /tutor_schedules/new
  def new
    @tutor_schedule = TutorSchedule.new
  end

  # GET /tutor_schedules/1/edit
  def edit
  end

  # POST /tutor_schedules or /tutor_schedules.json
  def create
    @tutor_schedule = TutorSchedule.new(tutor_schedule_params)

    respond_to do |format|
      if @tutor_schedule.save
        format.html { redirect_to tutor_schedule_url(@tutor_schedule), notice: "Tutor schedule was successfully created." }
        format.json { render :show, status: :created, location: @tutor_schedule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tutor_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tutor_schedules/1 or /tutor_schedules/1.json
  def update
    respond_to do |format|
      if @tutor_schedule.update(tutor_schedule_params)
        format.html { redirect_to tutor_schedule_url(@tutor_schedule), notice: "Tutor schedule was successfully updated." }
        format.json { render :show, status: :ok, location: @tutor_schedule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tutor_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutor_schedules/1 or /tutor_schedules/1.json
  def destroy
    @tutor_schedule.destroy

    respond_to do |format|
      format.html { redirect_to tutor_schedules_url, notice: "Tutor schedule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tutor_schedule
      @tutor_schedule = TutorSchedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tutor_schedule_params
      params.require(:tutor_schedule).permit(:tutor_id, :start_time, :active)
    end
end
