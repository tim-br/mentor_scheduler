def current_user
  session[:user]
end

get '/' do
  erb :'index'
end
 /new' do
  erb :'mentors/new'
end

get '/shifts' do
  @shifts = Shift.all
  erb :'shifts/index'
end

get '/calendar' do
  erb :'/calendar/index'
end

post '/verify_login' do
  @admin = Admin.find_by email: params[:email]
  if @admin && @admin.authenticate(params[:password])
    session[:user] = @admin
    redirect '/calendar'
  else
    redirect '/authentification_failed'
  end

end

get '/mentors/:id' do
  @mentor = Mentor.find params[:id]
  erb :'mentors/show'
end

get '/authentification_failed' do
  erb :'/authentification_failed'
end
