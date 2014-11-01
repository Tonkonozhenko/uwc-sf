Rails.application.routes.draw do
  root 'pages#offices_search'
  get 'bonus_plus_search' => 'pages#bonus_plus_search'
end
