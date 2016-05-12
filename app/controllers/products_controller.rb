class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  respond_to :json
  require 'json'
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  def listall
    return render :json => Product.all.as_json(:only => [:id, :name, :count, :row, :col, :price, :soldCount])
  end

  def modify
    pr = Product.find_by(name:product_params[:name])
    pr[:count] = product_params[:count]
    pr[:row] = product_params[:row]
    pr[:col] = product_params[:col]
    pr[:price] = product_params[:price]
    pr[:soldCount] = product_params[:soldCount]
    pr.save

    return render :json => pr.as_json(:only => [:id, :name, :count, :row, :col, :price, :soldCount])
  end

  def delete
    pr = Product.find_by(name:product_params[:name])
    pr.destroy
    return render json:{
      :resp => 200
    }
  end

  # => return phone numbers of customers who are interested in the product with the same col as the parameter
  def filterPeopleToBeNotified(column)
      filteredCustomers = []
      products = Product.where(col:column)
      allCustomers = Customer.all
      
      for pr in products
        for cust in allCustomers
          if cust[:interested].include? pr[:name]
            filteredCustomers.push(cust[:phone])
          end
        end
      end

      return filteredCustomers
  end

  # => send msgs to these customers
  def sendMsgs(phoneNos, msg)
    for num in phoneNos
      print msg
      ip_and_port = Net::HTTP.get(URI.parse('http://localhost:8000/OzekiIP.txt'))
      ip_and_port = ip_and_port.split("\n")
      ip_and_port = ip_and_port[0]
      print "IP AND PORT " + ip_and_port

      # => hardcoded ip_and_port
      #ip_and_port = '127.0.0.1:9501'

      # => url for GET request to ozeki msg sending
      ozeki_request = 'http://' + ip_and_port + '/api?username=admin&password=admin&action=sendmessage&messagetype=SMS:TEXT&recipient=' + num.to_s + "&messagedata=" + msg
      print "\nOZEKI " + ozeki_request
      
      # => send GET request
      Net::HTTP.get(URI.parse(ozeki_request))
    end
  end

  def insert
    pr = Product.new(product_params)
    pr.save

    return render :json => pr.as_json(:only => [:id, :name, :count, :row, :col, :price, :soldCount])
  end

  def listspecific
    pr = Product.find_by(name:product_params[:name])
    return render :json => pr.as_json(:only => [:id, :name, :count, :row, :col, :price, :soldCount])
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new

  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    # => get all people who might be interested in this new product
    receipentNos = filterPeopleToBeNotified(@product[:row])
    print "PHONE " + receipentNos.to_s

    # => send msgs to all the prospective customers
    sendMsgs(receipentNos, "Product " + @product[:name] + " has arrived. Shop immediately !!")


    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update

    priceLowering = false

    # => previous price of this product
    pr = Product.find_by(name:@product[:name])
    new_price = product_params[:price].to_i
    if new_price < pr[:price].to_i
      priceLowering = true
    end

    if priceLowering
      # => get all people who might be interested in this new product
      receipentNos = filterPeopleToBeNotified(product_params[:row])
      print "PHONE " + receipentNos.to_s

      # => send msgs to all the prospective customers
      sendMsgs(receipentNos, "Product " + @product[:name] + " has decreased in price to " + new_price.to_s + ". Shop immediately !!")
    end

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :count, :row, :col, :price, :soldCount)
    end

    def create_params
      params.permit(:name, :count, :row, :col, :price, :soldCount)
    end
end
