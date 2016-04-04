class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  respond_to :json
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
