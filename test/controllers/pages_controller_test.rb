require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "get index: is successful" do
    get root_path
    assert_response :success
  end
end
