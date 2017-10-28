Rails.application.routes.draw do
  match 'hits_login' => 'hits_counter/hc_sessions#login', :via => [:post]
  match 'hits_logout' => 'hits_counter/hc_sessions#logout', :via => [:get]
  match 'hits_report' => 'hits_counter/hc_matching_hits#index', :via => [:get]
end
