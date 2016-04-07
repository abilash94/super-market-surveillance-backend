class BillingCustomerCartsController < ApplicationController
  before_action :set_billing_customer_cart, only: [:show, :edit, :update, :destroy]
  respond_to :json
  def cart_arrival
    cart = billing_customer_cart_params[:cart]
    entry = BillingCustomerCart.new(billing_customer_cart_params)
    entry.save
    return render :json => entry.as_json(:only => [:id, :cart])
  end

  # GET /billing_customer_carts
  # GET /billing_customer_carts.json
  def index
    @billing_customer_carts = BillingCustomerCart.all
  end

  # GET /billing_customer_carts/1
  # GET /billing_customer_carts/1.json
  def show
  end

  # GET /billing_customer_carts/new
  def new
    @billing_customer_cart = BillingCustomerCart.new
  end

  # GET /billing_customer_carts/1/edit
  def edit
  end

  # POST /billing_customer_carts
  # POST /billing_customer_carts.json
  def create
    @billing_customer_cart = BillingCustomerCart.new(billing_customer_cart_params)

    respond_to do |format|
      if @billing_customer_cart.save
        format.html { redirect_to @billing_customer_cart, notice: 'Billing customer cart was successfully created.' }
        format.json { render :show, status: :created, location: @billing_customer_cart }
      else
        format.html { render :new }
        format.json { render json: @billing_customer_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing_customer_carts/1
  # PATCH/PUT /billing_customer_carts/1.json
  def update
    respond_to do |format|
      if @billing_customer_cart.update(billing_customer_cart_params)
        format.html { redirect_to @billing_customer_cart, notice: 'Billing customer cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @billing_customer_cart }
      else
        format.html { render :edit }
        format.json { render json: @billing_customer_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def deleteAll
    all = BillingCustomerCart.all
    for i in all
      i.destroy
    end
    return render json:{ :deleted => "all"}
  end

  # DELETE /billing_customer_carts/1
  # DELETE /billing_customer_carts/1.json
  def destroy
    @billing_customer_cart.destroy
    respond_to do |format|
      format.html { redirect_to billing_customer_carts_url, notice: 'Billing customer cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_customer_cart
      @billing_customer_cart = BillingCustomerCart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_customer_cart_params
      params.require(:billing_customer_cart).permit(:cart)
    end
end
