require 'test_helper'

class EmpsControllerTest < ActionController::TestCase
  setup do
    @emp = emps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create emp" do
    assert_difference('Emp.count') do
      post :create, emp: { code: @emp.code, name: @emp.name }
    end

    assert_redirected_to emp_path(assigns(:emp))
  end

  test "should show emp" do
    get :show, id: @emp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @emp
    assert_response :success
  end

  test "should update emp" do
    patch :update, id: @emp, emp: { code: @emp.code, name: @emp.name }
    assert_redirected_to emp_path(assigns(:emp))
  end

  test "should destroy emp" do
    assert_difference('Emp.count', -1) do
      delete :destroy, id: @emp
    end

    assert_redirected_to emps_path
  end
end
