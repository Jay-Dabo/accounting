Accounting::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root "pages#landing"
  get "home", to: "pages#home", as: "home", as: :user_root
  get "/contact", to: "pages#contact", as: "contact"
  post "/emailconfirmation", to: "pages#email", as: "email_confirmation"
  
  get "posts", to: "pages#posts", as: "posts"
  get "posts/:id", to: "pages#show_post", as: "post"

  resources :subscribers, only: :create
  devise_for :users
  resources :subscriptions do
    resources :payments
  end

  resources :firms do
    collection do
      post 'switch'
    end
    resources :memberships
    resources :fiscal_years, only: [:new, :create]
    resources :cash_flows, only: [:show]
    resources :balance_sheets, only: [:show]
    resources :income_statements, only: [:show]
    resources :spendings
    resources :payable_payments
    resources :receivable_payments
    resources :assets do
      collection do
        post 'refresh'
      end
    end
    resources :expenses
    resources :revenues
    resources :other_revenues
    resources :discards
    resources :funds
    resources :loans
    resources :expendables
    resources :merchandises
    resources :works
    resources :materials
    resources :products
    resources :assemblies
  end

  resources :assemblies do
    resources :processings, only: [:index]
  end

  resources :fiscal_years do
    collection do
      post 'closing'
    end
    resources :cash_flows, only: [:show]
    resources :balance_sheets, only: [:show]
    resources :income_statements, only: [:show]
  end

  namespace :admin do
    root "base#index"
    resources :users
    get "posts/drafts", to: "posts#drafts", as: "posts_drafts"
    get "posts/dashboard", to: "posts#dashboard", as: "posts_dashboard"
    resources :posts
    resources :plans
    resources :messages, only: [:index, :new, :create]
    resources :bookings      
  end

end
