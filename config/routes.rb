Rails.application.routes.draw do
  match 'hits_report' => 'hits_counter/hc_matching_hits#index', :via => [:get]
end
