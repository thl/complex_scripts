Rails.application.routes.draw do
  mount ComplexScripts::Engine => '/complex_scripts'
end