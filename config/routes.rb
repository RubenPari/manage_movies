Rails.application.routes.draw do
  get 'movies/exists', to: 'movies#exists'
  get 'movies', to: 'movies#get_by_id'
  get 'movies/get_all', to: 'movies#get_all'
  post 'movies/add', to: 'movies#create'
  delete 'movies/delete', to: 'movies#delete'
end
