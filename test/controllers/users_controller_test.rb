require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end

test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
 
 test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user)
    assert_not @user.admin?
    patch user_path(@user), params: {
                                    user: { password:              @user.password,
                                            password_confirmation: @user.password_confirmation,
                                            admin: @user.admin } }
  end

end
