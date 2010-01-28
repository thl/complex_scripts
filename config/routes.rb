ActionController::Routing::Routes.draw do |map|
  map.namespace(:complex_scripts) do |complex_scripts|
    complex_scripts.change_language 'session/change_language/:id', :controller => 'sessions', :action => 'change_language'
  end
  map.resources :languages
end