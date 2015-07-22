get '/' do 
  erb :'index'
end

get '/calendar' do
  erb :'/calendar/index'
end
