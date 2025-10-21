require "test_helper"

class TrainingDataControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get training_data_create_url
    assert_response :success
  end
end
