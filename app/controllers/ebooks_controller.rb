class EbooksController < ApplicationController
  require 'elib/Elib.rb'
  def index
    response = Elib::ElibAPI.get_products_from_elib('2014-12-14','2015-12-14')
    puts "yae", response
    @ebooks = response
  end
  def show
    # response = Elib::ElibAPI.get_products_from_elib('2014-12-14','2015-12-14')
    # puts "yae", response
    # @ebooks = response
    @ebook= Ebook.find(params[:id])
  end
  def create
    session[:s_ProductID] = params[:productID]
    session[:s_FormatGroupID] = params[:formatGroupId]
    puts 'test2', session[:s_FormatGroupID]
    redirect_to new_order_path
  end
end
