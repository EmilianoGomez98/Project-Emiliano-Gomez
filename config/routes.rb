Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#index'

  get 'add' => 'adds#add'
  post 'adds/create'

  get 'set' => 'sets#set'
  post 'sets/create'

  get 'replace' => 'replaces#replace'
  post 'replaces/create'

  get 'append' => 'appends#append'
  post 'appends/create'

  get 'preppend' => 'preppends#preppend'
  post 'preppends/create'

  get 'get' => 'gets#get'
  post 'gets/show'

  get 'getcas' => 'getcas#getcas'
  post 'getcas/show'

  get  'cas' => 'cas#cas'
  post 'cas/create'

end
