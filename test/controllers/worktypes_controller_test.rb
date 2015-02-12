require 'test_helper'

class WorktypesControllerTest < ActionController::TestCase
  setup do
    @worktype = worktypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:worktypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create worktype" do
    assert_difference('Worktype.count') do
      post :create, worktype: { name: @worktype.name }
    end

    assert_redirected_to worktype_path(assigns(:worktype))
  end

  test "should show worktype" do
    get :show, id: @worktype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @worktype
    assert_response :success
  end

  test "should update worktype" do
    patch :update, id: @worktype, worktype: { name: @worktype.name }
    assert_redirected_to worktype_path(assigns(:worktype))
  end

  test "should destroy worktype" do
    assert_difference('Worktype.count', -1) do
      delete :destroy, id: @worktype
    end

    assert_redirected_to worktypes_path
  end
end
