require 'test_helper'

class WorklogsControllerTest < ActionController::TestCase
  setup do
    @worklog = worklogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:worklogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create worklog" do
    assert_difference('Worklog.count') do
      post :create, worklog: { check: @worklog.check, comment: @worklog.comment, dept_id: @worklog.dept_id, emp_id: @worklog.emp_id, holiday: @worklog.holiday, rc_end: @worklog.rc_end, rc_start: @worklog.rc_start, reason: @worklog.reason, rest: @worklog.rest, wk_end: @worklog.wk_end, wk_start: @worklog.wk_start, workday: @worklog.workday, worktype: @worklog.worktype }
    end

    assert_redirected_to worklog_path(assigns(:worklog))
  end

  test "should show worklog" do
    get :show, id: @worklog
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @worklog
    assert_response :success
  end

  test "should update worklog" do
    patch :update, id: @worklog, worklog: { check: @worklog.check, comment: @worklog.comment, dept_id: @worklog.dept_id, emp_id: @worklog.emp_id, holiday: @worklog.holiday, rc_end: @worklog.rc_end, rc_start: @worklog.rc_start, reason: @worklog.reason, rest: @worklog.rest, wk_end: @worklog.wk_end, wk_start: @worklog.wk_start, workday: @worklog.workday, worktype: @worklog.worktype }
    assert_redirected_to worklog_path(assigns(:worklog))
  end

  test "should destroy worklog" do
    assert_difference('Worklog.count', -1) do
      delete :destroy, id: @worklog
    end

    assert_redirected_to worklogs_path
  end
end
