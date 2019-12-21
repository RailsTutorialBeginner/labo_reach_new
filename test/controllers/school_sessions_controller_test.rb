require 'test_helper'

class SchoolSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get school_sessions_new_url
    assert_response :success
  end

end
