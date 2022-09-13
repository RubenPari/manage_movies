Rails.application.routes.draw do
  get 'movies/exists', to: 'movies#exists'
end
