Rails.application.routes.draw do
  get 'movies/exists', to: 'movies#exists'
  get 'movies', to: 'movies#get_by_id'
  get 'movies/get_all', to: 'movies#get_all'
  post 'movies/add', to: 'movies#create'
  delete 'movies/delete', to: 'movies#delete'

  get 'tv_series/exists', to: 'tv_series#exists'
  get 'tv_series', to: 'tv_series#get_by_id'
  get 'tv_series/get_all', to: 'tv_series#get_all'
  post 'tv_series/add', to: 'tv_series#create'
  delete 'tv_series/delete', to: 'tv_series#delete'
end
