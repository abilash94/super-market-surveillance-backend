class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  respond_to :json

  # GET /customers
  # GET /customers.json

  def listall
    return render :json => Customer.all.as_json(:only => [:id, :custID, :interested, :bought])
  end

  def modify
    pr = Customer.find_by(custID:customer_params[:custID])
    pr[:interested] = customer_params[:interested]
    pr[:bought] = customer_params[:bought]
    pr.save

    return render :json => pr.as_json(:only => [:id, :custID, :interested, :bought])
  end

  def listspecific
    pr = Customer.find_by(custID:customer_params[:custID])
    return render :json => pr.as_json(:only => [:id, :custID, :interested, :bought])
  end

  def index
    @customers = Customer.all
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    bought = customer_params[:bought]
    interestedBefore = customer_params[:interested]
    currentCart = BillingCustomerCart.first[:cart]
    BillingCustomerCart.first.destroy

    bought = bought.split(' ')
    interestedBefore = interestedBefore.split(' ')
    currentCart = currentCart.split(' ')

    
    # => remove all items that are bought by the customer
    notBought = []
    alreadyPresent = false
    for possibleItem in currentCart
      alreadyPresent = false
      for alreadyBought in bought
        if possibleItem == alreadyBought
          alreadyPresent = true
        end
      end
      if not alreadyPresent
        notBought.push(possibleItem)
      end
    end
    
    # => remove already interested products
    newInterest = true
    newInterests = []
    for currentInterest in notBought
      for alreadyInterested in interestedBefore
        if alreadyInterested == currentInterest
          newInterest = false
        end
      end
      if newInterest
        newInterests.push(currentInterest)
      end
    end
    
    # => concatenate the newly interested products
    finalInterests = interestedBefore
    for i in newInterests
      finalInterests = finalInterests.push(i)
    end
    cust = Customer.find_by(custID:customer_params[:custID])


    finalInterestsString = ""
    for i in finalInterests
      finalInterestsString = finalInterestsString + " " + i
    end

    cust[:interested] = finalInterestsString
    cust.save

    return render :json => finalInterests.to_s
    # respond_to do |format|
    #   if @customer.update(customer_params)
    #     format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @customer }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @customer.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:custID, :interested, :bought)
    end
end
