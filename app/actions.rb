def current_user
  session[:user]
end

get '/' do
  erb :'index'
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

get '/mentors' do
  @mentors = Mentor.all
  erb :'mentors/index'
end

post '/mentors' do
  @full_name = params[:full_name]
  @email = params[:email]
  @mentor =   Mentor.create(full_name: @full_name, email: @email)
  redirect '/mentors'
end

get '/mentors/new' do
  erb :'mentors/new'
end

get '/mentors/:id' do
  @mentor = Mentor.find params[:id]
  erb :'mentors/show'
end

get '/mentors/:id/shifts' do
  @mentor = Mentor.find params[:id]
  erb :'mentors/show/shifts'
end

post '/mentors/:id/shifts' do
  redirect '/mentors/:id/shifts'
end

get '/mentors/:id/shifts/new' do
  @mentor = Mentor.find(params[:id])
  erb :'/shifts/new'
end


get '/authentification_failed' do
  erb :'/authentification_failed'
end
