require "application_system_test_case"

class TutorSchedulesTest < ApplicationSystemTestCase
  setup do
    @tutor_schedule = tutor_schedules(:one)
  end

  test "visiting the index" do
    visit tutor_schedules_url
    assert_selector "h1", text: "Tutor schedules"
  end

  test "should create tutor schedule" do
    visit tutor_schedules_url
    click_on "New tutor schedule"

    check "Active" if @tutor_schedule.active
    fill_in "Start time", with: @tutor_schedule.start_time
    fill_in "Tutor", with: @tutor_schedule.tutor_id
    click_on "Create Tutor schedule"

    assert_text "Tutor schedule was successfully created"
    click_on "Back"
  end

  test "should update Tutor schedule" do
    visit tutor_schedule_url(@tutor_schedule)
    click_on "Edit this tutor schedule", match: :first

    check "Active" if @tutor_schedule.active
    fill_in "Start time", with: @tutor_schedule.start_time
    fill_in "Tutor", with: @tutor_schedule.tutor_id
    click_on "Update Tutor schedule"

    assert_text "Tutor schedule was successfully updated"
    click_on "Back"
  end

  test "should destroy Tutor schedule" do
    visit tutor_schedule_url(@tutor_schedule)
    click_on "Destroy this tutor schedule", match: :first

    assert_text "Tutor schedule was successfully destroyed"
  end
end
