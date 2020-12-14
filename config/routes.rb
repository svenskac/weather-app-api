Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/weather' do
    get '/locations/:id', to: 'weather#locations'
    get '/summary', to: 'weather#summary'
    get '/api', to: 'weather#api'
  end
end
