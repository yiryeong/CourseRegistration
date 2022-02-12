require "application_system_test_case"

class TutorInfosTest < ApplicationSystemTestCase
  setup do
    @tutor_info = tutor_infos(:one)
  end

  test "visiting the index" do
    visit tutor_infos_url
    assert_selector "h1", text: "Tutor infos"
  end

  test "should create tutor info" do
    visit tutor_infos_url
    click_on "New tutor info"

    fill_in "Name", with: @tutor_info.name
    click_on "Create Tutor info"

    assert_text "Tutor info was successfully created"
    click_on "Back"
  end

  test "should update Tutor info" do
    visit tutor_info_url(@tutor_info)
    click_on "Edit this tutor info", match: :first

    fill_in "Name", with: @tutor_info.name
    click_on "Update Tutor info"

    assert_text "Tutor info was successfully updated"
    click_on "Back"
  end

  test "should destroy Tutor info" do
    visit tutor_info_url(@tutor_info)
    click_on "Destroy this tutor info", match: :first

    assert_text "Tutor info was successfully destroyed"
  end
end
