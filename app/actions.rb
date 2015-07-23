def current_user
  session[:user]
end

get '/test' do 

end

get '/' do
  erb :'index'
end

get '/calendar' do
  erb :'/calendar/index'
end

post '/verify_login' do
  @admin = Admin.find_by email: params[:admin_email]
  if @admin && @admin.authenticate(params[:password])
    session[:user] = @admin
    redirect '/calendar'
  else
    redirect '/authentification_failed'
  end

end

get '/authentification_failed' do
  erb :'/authentification_failed'
end
