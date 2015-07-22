class ProductsController < ApplicationController
  before_action :require_login, except: [:index, :show, :merchant_products]
  before_action :find_product, only: [:show, :edit, :update, :destroy, :retire]

  def index
    @products = Product.active_product
  end

  def show
    @order_item = current_order.order_items.new
  end

  def new
    @product = Product.new
    user = User.find(params[:user_id])
    @user_id = user.id
  end

  def create
    @product = Product.new(user_params[:product])
    @user_id = @product.user_id
    if @product.save
      redirect_to product_path(@product)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @product.update(user_params[:product])

    if @product.save
      redirect_to user_path(@product.user_id)
    else
      render :edit
    end
  end

  def retire
    @product.retire_toggle!
    @product.save
    redirect_to user_path(@product.user_id)
  end

  def merchant_products
    @merchant = @merchants.find(params[:id])
  end

  private

  def find_product
    @product = Product.find(params[:id])
  end

  def user_params
    params.permit(product: [:name, :price, :desc, :stock, :photo_url, :user_id, :retired, :category_ids => []])
  end
end
