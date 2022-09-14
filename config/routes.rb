Rails.application.routes.draw do
  get 'movies/exists', to: 'movies#exists'
  post 'movies/add', to: 'movies#create'
  delete 'movies/delete', to: 'movies#delete'
end
