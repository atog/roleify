require File.dirname(__FILE__) + '/test_helper.rb'
require 'action_controller/test_process'

Roleify::Role.configure(%w(a b c)) do
  {
    :a => { :issues =>  :all },
    :b => { :issues => "index" }
  }
end

class IssuesController < ActionController::Base
  include Roleify::RoleifyableController
  include Clearance::Authentication

  before_filter :allowed?

  attr_accessor :current_user
  
  def index        
    render :nothing => true
  end

  def edit
    render :nothing => true
  end
end

class IssuesControllerTest < ActionController::TestCase
  def setup
    @controller = IssuesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new  

    ActionController::Routing::Routes.draw do |map|
      map.resources :issues
    end
  end

  def test_admin_allowed
    @controller.current_user= CurrentUser.new(:admin)
    get :index
    assert_response :success
  end

  def test_admin_allowed_string
    @controller.current_user= CurrentUser.new("admin")
    get :index
    assert_response :success
  end

  def test_index_a_allowed
    @controller.current_user= CurrentUser.new(:a)
    get :index
    assert_response :success
  end

  def test_index_b_allowed
    @controller.current_user= CurrentUser.new(:b)
    get :index
    assert_response :success
  end

  def test_index_b_not_allowed
    @controller.current_user= CurrentUser.new(:b)
    get :edit, :id => "123"
    assert_response :redirect
  end

    def test_index_c_not_allowed
    @controller.current_user= CurrentUser.new(:c)
    get :edit, :id => "123"
    assert_response :redirect
  end


end