Rails.application.routes.draw do
  root 'pages#office_search'
  get 'office_search' => 'pages#office_search'
  get 'bonus_plus_search' => 'pages#bonus_plus_search'
end
