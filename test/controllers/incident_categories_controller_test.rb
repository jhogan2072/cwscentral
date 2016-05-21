require 'test_helper'

class IncidentCategoriesControllerTest < ActionController::TestCase
  setup do
    @incident_category = incident_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incident_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incident_category" do
    assert_difference('IncidentCategory.count') do
      post :create, incident_category: { category: @incident_category.category }
    end

    assert_redirected_to incident_category_path(assigns(:incident_category))
  end

  test "should show incident_category" do
    get :show, id: @incident_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @incident_category
    assert_response :success
  end

  test "should update incident_category" do
    patch :update, id: @incident_category, incident_category: { category: @incident_category.category }
    assert_redirected_to incident_category_path(assigns(:incident_category))
  end

  test "should destroy incident_category" do
    assert_difference('IncidentCategory.count', -1) do
      delete :destroy, id: @incident_category
    end

    assert_redirected_to incident_categories_path
  end
end
