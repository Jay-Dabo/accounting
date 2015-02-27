Accounting::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root "pages#landing"
  get "home", to: "pages#home", as: "home", as: :user_root
  get "/contact", to: "pages#contact", as: "contact"
  post "/emailconfirmation", to: "pages#email", as: "email_confirmation"
  
  get "posts", to: "pages#posts", as: "posts"
  get "posts/:id", to: "pages#show_post", as: "post"
  
  devise_for :users
  resources :firms do
    resources :balance_sheets
    resources :income_statements    
    resources :spendings
      resources :assets
      # put "assets"
      resources :expenses
    resources :revenues
    resources :funds
    resources :merchandises
  end


  namespace :admin do
    root "base#index"
    resources :users
    get "posts/drafts", to: "posts#drafts", as: "posts_drafts"
    get "posts/dashboard", to: "posts#dashboard", as: "posts_dashboard"
    resources :posts
  end

end
