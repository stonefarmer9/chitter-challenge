require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models/message'
require './models/user'

set :database_file, 'config/database.yml'

class App < Sinatra::Base

  enable :sessions
  enable :method_override
  register Sinatra::Flash

  get '/' do
    @messages = Message.all
    erb :index
  end

  post '/message' do
    @message = Message.create({ :content => params[:message] })
    redirect '/'
  end

  get '/signup' do
    session[:error]||= nil
    @error = session[:error]
    erb :signup
  end

  post '/signup' do
    session[:user] = User.create(name: params[:Name],
    username: params[:Username], email: params[:Email], password: params[:Password])
    if session[:user].id!= nil
      redirect '/profile/:id'
    else
      session[:error] = "Email already in use!! Try logging in..."
      redirect '/signup'
    end
  end

  get '/profile/:id' do
    @id = session[:user].id
    @user = User.find(@id)
    erb :profile
  end

end
