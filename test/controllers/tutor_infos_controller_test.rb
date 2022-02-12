require "test_helper"

class TutorInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tutor_info = tutor_infos(:one)
  end

  test "should get index" do
    get tutor_infos_url
    assert_response :success
  end

  test "should get new" do
    get new_tutor_info_url
    assert_response :success
  end

  test "should create tutor_info" do
    assert_difference("TutorInfo.count") do
      post tutor_infos_url, params: { tutor_info: { name: @tutor_info.name } }
    end

    assert_redirected_to tutor_info_url(TutorInfo.last)
  end

  test "should show tutor_info" do
    get tutor_info_url(@tutor_info)
    assert_response :success
  end

  test "should get edit" do
    get edit_tutor_info_url(@tutor_info)
    assert_response :success
  end

  test "should update tutor_info" do
    patch tutor_info_url(@tutor_info), params: { tutor_info: { name: @tutor_info.name } }
    assert_redirected_to tutor_info_url(@tutor_info)
  end

  test "should destroy tutor_info" do
    assert_difference("TutorInfo.count", -1) do
      delete tutor_info_url(@tutor_info)
    end

    assert_redirected_to tutor_infos_url
  end
end
