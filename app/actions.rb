def current_user
  session[:user]
end

get '/' do
  erb :'index'
end

get '/account' do
  if current_user
    @admin = session[:user]
    erb :'admins/show'
  else
    redirect '/permission_denied'
  end
end

get '/logout' do
  session[:user] = nil
  redirect '/'
end

get '/shifts' do
  if current_user
    @shifts = Shift.all
    erb :'shifts/index'
  else
    redirect '/permission_denied'
  end
end

get '/calendar' do
  if current_user
    @schedule = Schedule.new
    erb :'/calendar/index'
  else
    redirect '/permission_denied'
  end
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
  if current_user
    @mentors = Mentor.all
    erb :'mentors/index'
  else
    redirect '/authentification_failed'
  end
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

post '/mentors/new' do 
  @mentor = Mentor.new(params[:mentor])
  if @mentor.save
    if params[:monday_start_time] != 0
      for i in (params[:monday_start_time]...params[:monday_end_time])
        @constraint_monday = Constraint.create(mentor_id: @mentor.id, day: 1, hour: i)
        @constraint_monday.save
      end
    elsif params[:tuesday_start_time] != 0
      for i in (params[:tuesday_start_time]...params[:tuesday_end_time])
        @constraint_tuesday = Constraint.create(mentor_id: @mentor.id, day: 2, hour: i)
        @constraint_tuesday.save
      end
    elsif params[:wednesday_start_time] != 0
      for i in (params[:wednesday_start_time]...params[:wednesday_end_time])
        @constraint_wednesday = Constraint.create(mentor_id: @mentor.id, day: 3, hour: i)
        @constraint_wednesday.save
      end
    elsif params[:thursday_start_time] != 0
      for i in (params[:thursday_start_time]...params[:thursday_end_time])
        @constraint_thursday = Constraint.create(mentor_id: @mentor.id, day: 4, hour: i)
        @constraint_thursday.save
      end
    elsif params[:friday_start_time] != 0
      for i in (params[:friday_start_time]...params[:friday_end_time])
        @constraint_friday = Constraint.create(mentor_id: @mentor.id, day: 5, hour: i)
        @constraint_friday.save
      end
    end
    # File.open('images/' + params['photo'][:filename], "w") do |f|
    #   f.write(params['photo'][:tempfile].read)
    # end
  end
end

get '/mentors/:id' do
  if current_user
    @mentor = Mentor.find params[:id]
    erb :'mentors/show'
  else
    redirect '/permission_denied'
  end
end

post '/calendar' do 
  redirect '/calendar'
end

post '/optimize' do 
  @schedule = Schedule.new
  @sa = SimulatedAnneal.new(@schedule)
  @sa.optimize(10, 0.1)
  @schedule = @sa.best_solution
  erb :'/calendar/index'
end

get '/authentification_failed' do
  erb :'/authentification_failed'
end

get '/permission_denied' do
  "PERMISSION DENIED"
end
