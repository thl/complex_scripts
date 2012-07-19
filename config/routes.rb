Rails.application.routes.draw do
  namespace :complex_scripts do
    match 'session/change_language/:id' => 'sessions#change_language', :as => :change_language
    resources :languages
  end
end