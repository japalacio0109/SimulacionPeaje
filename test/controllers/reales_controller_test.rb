require 'test_helper'

class RealesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get reales_index_url
    assert_response :success
  end

  test "should get calculate" do
    get reales_calculate_url
    assert_response :success
  end

end
