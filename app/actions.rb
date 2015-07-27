def current_user
  session[:user]
end

get '/' do
  erb :'index'
end

get '/account' do
  @admin = session[:user]
  erb :'admins/show'
end

get '/logout' do
  session[:user] = nil
  redirect '/'
end

get '/shifts' do
  @shifts = Shift.all
  erb :'shifts/index'
end

get '/calendar' do
  @schedule = Schedule.new
  erb :'/calendar/index'
end

post '/change_admin_password' do
  @admin = session[:user]
  if @admin.authenticate(params[:password])
    @admin.update(password: params[:new_password], password_confirmation: params[:new_password_confirmation])
    if @admin.valid?
      @admin.save
      redirect '/calendar'
    else
      @admin.reload
      redirect '/account?passwords_dont_match=true'
    end
  else
      redirect '/authentification_failed'
  end
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
  if @mentor.save
    redirect '/mentors'
  end
end

get '/mentors/new' do
  erb :'mentors/new'
end

get '/mentors/:id' do
  @mentor = Mentor.find params[:id]
  erb :'mentors/show'
end

post '/calendar' do 
  redirect '/calendar'
end

post '/optimize' do 
  @schedule = Schedule.new
  @sa = SimulatedAnneal.new(@schedule)
  @sa.optimize(10, 0.1)
  # @schedule = @sa.best_solution
  erb :'/calendar/index'
end

# post '/mentor/shifts/new' do
#   @shifts = Shift.where(day: params[:day]).where(hour: [params[:start_time]...params[:end_time]] )
#   @shifts.each do |shift|
#     shift.mentor = Mentor.find(params[:mentor])
#     shift.save
#   end
#   redirect '/calendar'
# end

get '/authentification_failed' do
  erb :'/authentification_failed'
end
