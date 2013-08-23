Ncp::Application.routes.draw do

  resources :activities


  mount Ckeditor::Engine => '/ckeditor'



  resources :projects

  match '/about' => 'static_pages#about'
  match '/contacts' => 'static_pages#contacts'
  match '/cooperation' => 'static_pages#cooperation'
  match '/vacancies' => 'static_pages#vacancies'
  
  root :to => 'static_pages#index'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
