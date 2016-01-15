require 'test_helper'

class WorkAssignmentsControllerTest < ActionController::TestCase
  setup do
    @work_assignment = work_assignments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_assignments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_assignment" do
    assert_difference('WorkAssignment.count') do
      post :create, work_assignment: { earliest_start: @work_assignment.earliest_start, end_date: @work_assignment.end_date, ideal_start: @work_assignment.ideal_start, latest_start: @work_assignment.latest_start, contact_id: @work_assignment.contact_id, paid: @work_assignment.paid, start_date: @work_assignment.start_date, student_gradelevel: @work_assignment.student_gradelevel, student_id: @work_assignment.student_id, work_day: @work_assignment.work_day }
    end

    assert_redirected_to work_assignment_path(assigns(:work_assignment))
  end

  test "should show work_assignment" do
    get :show, id: @work_assignment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @work_assignment
    assert_response :success
  end

  test "should update work_assignment" do
    patch :update, id: @work_assignment, work_assignment: { earliest_start: @work_assignment.earliest_start, end_date: @work_assignment.end_date, ideal_start: @work_assignment.ideal_start, latest_start: @work_assignment.latest_start, contact_id: @work_assignment.contact_id, paid: @work_assignment.paid, start_date: @work_assignment.start_date, student_gradelevel: @work_assignment.student_gradelevel, student_id: @work_assignment.student_id, work_day: @work_assignment.work_day }
    assert_redirected_to work_assignment_path(assigns(:work_assignment))
  end

  test "should destroy work_assignment" do
    assert_difference('WorkAssignment.count', -1) do
      delete :destroy, id: @work_assignment
    end

    assert_redirected_to work_assignments_path
  end
end
