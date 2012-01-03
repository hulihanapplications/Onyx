require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/hits_controller'

# Re-raise errors caught by the controller.
class Admin::HitsController; def rescue_action(e) raise e end; end

class Admin::HitsControllerTest < Test::Unit::TestCase
  fixtures :admin_hits

  def setup
    @controller = Admin::HitsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = hits(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:hits)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:hits)
    assert assigns(:hits).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:hits)
  end

  def test_create
    num_hits = Hits.count

    post :create, :hits => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_hits + 1, Hits.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:hits)
    assert assigns(:hits).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Hits.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Hits.find(@first_id)
    }
  end
end
