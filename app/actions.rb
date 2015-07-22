get '/' do
  erb :'index'
end

get '/calendar' do
  erb :'/calendar/index'
end

post '/verify_login' do
  admin_email = params[:admin_email]
  password = params[:password]
  current_admin = Admin.find_by email: admin_email
  if current_admin && current_admin.authenticate(password)
    session["admin_id"] = current_admin.id
    puts session["admin_id"]
  end
  redirect '/calendar'

end
