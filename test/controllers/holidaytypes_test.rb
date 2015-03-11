require 'test_helper'

class HolidaytypesControllerTest < ActionController::TestCase
  setup do
    @holidaytype = holidaytypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:holidaytypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create holiday" do
    assert_difference('Holidaytype.count') do
      post :create, holiday: { name: @holidaytype.name }
    end

    assert_redirected_to holidaytype_path(assigns(:holidaytype))
  end

  test "should show holidaytype" do
    get :show, id: @holidaytype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @holidaytype
    assert_response :success
  end

  test "should update holiday" do
    patch :update, id: @holidaytype, holidaytype: { name: @holidaytype.name }
    assert_redirected_to holidaytype_path(assigns(:holidaytype))
  end

  test "should destroy holidaytype" do
    assert_difference('Holidaytype.count', -1) do
      delete :destroy, id: @holidaytype
    end

    assert_redirected_to holidaytypes_path
  end
end
