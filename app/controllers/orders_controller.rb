class OrdersController < ApplicationController
  before_action :authenticate_user!
  def index
    puts 'session', session[:s_ProductID]
    if session[:s_ProductID] !=nil
      @elib_orders = ElibOrder.all
    else
      redirect_to root_url
    end
  end
  def new
    if session[:s_ProductID] !=nil
      puts 'test' ,session[:s_ProductID]
      puts 'test2', session[:s_FormatGroupID]
      puts 'current user', current_user.id
      #@elib_order = current_user.elib_orders.build
      completeOrder = Elib::OrderHandler.new(session[:s_ProductID],session[:s_FormatGroupID],current_user.id)
      completeOrder.send_order_to_elib
      completeOrder.save_order
      session.delete(:s_ProductID)
      session.delete(:s_FormatGroupID)
      puts 'nil awdawdaw', session[:s_ProductID]
    else
      redirect_to root_url
    end

  end
  def create

  end
end
