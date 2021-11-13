# 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

require 'sinatra'
require './user'
require 'digest'
User.auto_upgrade!

@link = "http://localhost:5000"

get '/' do
  erb :home
end

get '/login' do
  erb :login
end

get '/signup' do
  erb :signup
end

enable :sessions
post '/login' do
  user = User.all(:userId => params[:userId], :password => Digest::SHA256.hexdigest(params[:password]))
  if user.size == 1
    session[:userId] = user[0].userId
    @winnings = 0
    @loss = 0
    @profit = 0
    user = User.get(session[:userId])
    @totalWinnings = user.totalWinnings
    @totalLosses = user.totalLosses
    @totalProfit = user.totalProfit
    erb :gamblesite
  else
    @message = "Login failure"
    erb :login
  end
end

enable :sessions
post '/bet' do
  puts session[:userId]
  if session[:userId] == nil
    @message = "Please login to start betting."
    return erb :login
  end
  number = 1 + rand(6)
  @winnings = 0
  @loss = 0
  @profit = 0
  user = User.get(session[:userId])
  @totalWinnings = user.totalWinnings
  @totalLosses = user.totalLosses
  @totalProfit = user.totalProfit
  if number == params[:dicevalue].to_i
    @winnings += params[:money].to_i
  else
    @loss += params[:money].to_i
  end
  @profit = @winnings - @loss
  @totalWinnings += @winnings
  @totalLosses += @loss
  @totalProfit += @profit
  user.totalWinnings = @totalWinnings
  user.totalLosses = @totalLosses
  user.totalProfit = @totalProfit
  user.save
  erb :gamblesite
end

enable :sessions
post '/logout' do
  session.delete(:userId)
  erb :home
end

post '/register' do
  checkUser = User.all(:userId => params[:userId])
  if checkUser.size > 0
    @message = "User already exists."
    return erb :signup
  end
  user = User.new
  user.firstName = params[:firstName]
  user.lastName = params[:lastName]
  user.userId = params[:userId]
  user.password = Digest::SHA256.hexdigest(params[:password])
  user.totalWinnings = 0
  user.totalLosses = 0
  user.totalProfit = 0
  user.save
  erb :home
end
