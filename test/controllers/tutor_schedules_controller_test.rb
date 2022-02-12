require "test_helper"

class TutorSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tutor_schedule = tutor_schedules(:one)
  end

  test "should get index" do
    get tutor_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_tutor_schedule_url
    assert_response :success
  end

  test "should create tutor_schedule" do
    assert_difference("TutorSchedule.count") do
      post tutor_schedules_url, params: { tutor_schedule: { active: @tutor_schedule.active, start_time: @tutor_schedule.start_time, tutor_id: @tutor_schedule.tutor_id } }
    end

    assert_redirected_to tutor_schedule_url(TutorSchedule.last)
  end

  test "should show tutor_schedule" do
    get tutor_schedule_url(@tutor_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_tutor_schedule_url(@tutor_schedule)
    assert_response :success
  end

  test "should update tutor_schedule" do
    patch tutor_schedule_url(@tutor_schedule), params: { tutor_schedule: { active: @tutor_schedule.active, start_time: @tutor_schedule.start_time, tutor_id: @tutor_schedule.tutor_id } }
    assert_redirected_to tutor_schedule_url(@tutor_schedule)
  end

  test "should destroy tutor_schedule" do
    assert_difference("TutorSchedule.count", -1) do
      delete tutor_schedule_url(@tutor_schedule)
    end

    assert_redirected_to tutor_schedules_url
  end
end
