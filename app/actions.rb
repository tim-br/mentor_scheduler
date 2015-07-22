get '/' do
  erb :'index'
end

get '/calendar' do
  erb :'/calendar/index'
end

post '/verify_login' do
  admin_email = params[:admin_email]
  password = params[:password]
  redirect '/calendar'
end
