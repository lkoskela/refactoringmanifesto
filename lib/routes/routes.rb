get '/' do
  @number_of_signatories = Signatory.count
  @manifesto = Manifesto.commandments
  erb :manifesto
end

get '/signatories' do
  @signatories = Signatory.all(:order => [ :created_at.desc ])
  erb :signatories
end

post '/signatories' do
  new_signatory = Signatory.new(:name => params['name'], :created_at => DateTime.now)
  new_signatory.save
  @added = new_signatory.name
  @signatories = Signatory.all(:order => [ :created_at.desc ])
  erb :signatories
end
