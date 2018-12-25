require 'test_helper'


class GradeTest < ActionDispatch::IntegrationTest

  def setup
    @grade = grades(:one)
  end

  test "should be valid" do
    assert  @grade.valid?
  end


end
