require 'test_helper'

class MergesControllerTest < ActionController::TestCase
  test "should get merge_organizations" do
    get :merge_organizations
    assert_response :success
  end

  test "should get merge_contacts" do
    get :merge_contacts
    assert_response :success
  end

end
