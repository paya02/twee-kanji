require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get events_show_url
    assert_response :success
  end

  test "should get add" do
    get events_add_url
    assert_response :success
  end

  test "should get edit" do
    get events_edit_url
    assert_response :success
  end

end
