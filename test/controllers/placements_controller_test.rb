require 'test_helper'

class PlacementsControllerTest < ActionController::TestCase
  setup do
    @placement = placements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:placements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create placement" do
    assert_difference('Placement.count') do
      post :create, placement: { earliest_start: @placement.earliest_start, end_date: @placement.end_date, ideal_start: @placement.ideal_start, latest_start: @placement.latest_start, contact_id: @placement.contact_id, paid: @placement.paid, start_date: @placement.start_date, student_gradelevel: @placement.student_gradelevel, student_id: @placement.student_id, work_day: @placement.work_day }
    end

    assert_redirected_to placement_path(assigns(:placement))
  end

  test "should show placement" do
    get :show, id: @placement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @placement
    assert_response :success
  end

  test "should update placement" do
    patch :update, id: @placement, placement: { earliest_start: @placement.earliest_start, end_date: @placement.end_date, ideal_start: @placement.ideal_start, latest_start: @placement.latest_start, contact_id: @placement.contact_id, paid: @placement.paid, start_date: @placement.start_date, student_gradelevel: @placement.student_gradelevel, student_id: @placement.student_id, work_day: @placement.work_day }
    assert_redirected_to placement_path(assigns(:placement))
  end

  test "should destroy placement" do
    assert_difference('Placement.count', -1) do
      delete :destroy, id: @placement
    end

    assert_redirected_to placements_path
  end
end
