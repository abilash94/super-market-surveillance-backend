require 'test_helper'

class BillingCustomerCartsControllerTest < ActionController::TestCase
  setup do
    @billing_customer_cart = billing_customer_carts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:billing_customer_carts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create billing_customer_cart" do
    assert_difference('BillingCustomerCart.count') do
      post :create, billing_customer_cart: { cart: @billing_customer_cart.cart }
    end

    assert_redirected_to billing_customer_cart_path(assigns(:billing_customer_cart))
  end

  test "should show billing_customer_cart" do
    get :show, id: @billing_customer_cart
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @billing_customer_cart
    assert_response :success
  end

  test "should update billing_customer_cart" do
    patch :update, id: @billing_customer_cart, billing_customer_cart: { cart: @billing_customer_cart.cart }
    assert_redirected_to billing_customer_cart_path(assigns(:billing_customer_cart))
  end

  test "should destroy billing_customer_cart" do
    assert_difference('BillingCustomerCart.count', -1) do
      delete :destroy, id: @billing_customer_cart
    end

    assert_redirected_to billing_customer_carts_path
  end
end
