require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user    = users(:peng)
    @user2   = users(:rongtongjin)
    @teacher = users(:teacherluo)
    @course1 = courses(:one)
    @course2 = courses(:two)
    @course3 = courses(:three)

  end

  test "should not get courses when not logged in" do
    get courses_path
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should not get new when not logged in" do
    get new_course_path
    assert_not flash.empty?
    assert_redirected_to root_url
  end


  test "should not get quit_course when not logged in" do
    get quit_course_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  # test "should not get credit when not logged in" do
  #   get credit_courses_path(@user)
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  # end


end