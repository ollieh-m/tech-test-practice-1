Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :programming_language_suggestions, only: :new
  get "programming_language_suggestions", to: "programming_language_suggestions#create"
end
