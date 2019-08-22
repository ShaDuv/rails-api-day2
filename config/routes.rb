Rails.application.routes.draw do
  resources :places do
    resources :reviews
  end

  get '/top_reviewed', to: 'places#by_avg_review'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
