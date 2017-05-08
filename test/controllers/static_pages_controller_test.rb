require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Ruby on rails"
  end

  test "should get contact" do
    get about_path
    assert_response :sucess
    assert_select "title", "Help | Ruby on rails"
  end

  test "should get about" do
    get contact_path
    assert_response :sucess
    assert_select "title", "About | Ruby on rails"
  end

 test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
  end

end
