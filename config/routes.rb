Rails.application.routes.draw do
  namespace :complex_scripts do
    get 'session/change_language/:id', to: 'sessions#change_language', as: :change_language
    resources :languages
  end
end