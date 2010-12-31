enable :sessions

before do
  headers 'Content-Type' => "text/html;charset=utf-8",
      'Pragma' => 'no-cache',
      'Cache-Control' => 'no-store, no-cache, must-revalidate, max-age=0',
      'Last-Modified' => Time.now.httpdate
end

before /\/admin.*/ do
  session[:last_requested_protected_path] = request.path_info
  redirect '/login' if session[:user].nil?
end

get '/' do
  @number_of_signatories = Signatory.count
  @manifesto = Manifesto.commandments
  erb :manifesto
end

get '/signatories/?' do
  @signatories = Signatory.all(:order => [ :created_at.desc ])
  erb :signatories
end

post '/signatories/?' do
  new_signatory = Signatory.new(:name => params['name'], :created_at => DateTime.now)
  new_signatory.save
  @added = new_signatory.name
  @signatories = Signatory.all(:order => [ :created_at.desc ])
  redirect '/signatories'
end

get '/login/?' do
  erb :login
end

get '/logout/?' do
  session[:user] = nil
  redirect '/admin'
end

post '/login/?' do
  session[:user] = Authentication.authenticate(params['username'], params['password'])
  redirect '/login' if session[:user].nil?
  @user = session[:user]
  redirect session[:last_requested_protected_path] ||= '/admin'
end

get '/admin/?' do
  @signatories = Signatory.all(:order => [ :created_at.desc ])
  @user = session[:user]
  erb :admin
end

get '/admin/destroy/:id' do |id|
  signatory = Signatory.get(id)
  signatory.destroy unless signatory.nil?
  redirect '/admin'
end
