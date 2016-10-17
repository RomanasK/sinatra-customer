require 'sinatra/base'
require './customer'
require './customer_generator'
require './main'
require 'pg'
require 'pry'
require 'pry-nav'

$pg = PGconn.connect("localhost", 5432, '', '', "customer", "postgres", "123456")


class ManoApp < Sinatra::Base

  get '/' do

    @per_page = 10
    @page = params['page'].to_i
    @customers = Customer.all(@per_page, @page)
    @customers_count= Customer.count / @per_page
    @last_page = @customers_count / @per_page
    erb :main
  end

  get '/customers/:id' do
      @customer = Customer.find(params[:id])
      erb :show_customer
    end

  get '/customers/:id/edit' do
    @customer = Customer.find(params[:id])
    erb :edit
  end

  post '/customers' do
   @customer = Customer.find(params[:id])
   @customer.update(params)
   redirect "customers/#{params[:id]}"
  end

  def pg
    $pg
  end

end

ManoApp.run!
