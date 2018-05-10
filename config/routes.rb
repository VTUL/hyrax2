Rails.application.routes.draw do
  
  mount Riiif::Engine => 'images', as: :riiif if Hyrax.config.iiif_image_server?
  mount Blacklight::Engine => '/'
  
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'users/auth/cas', to: 'users/omniauth_callbacks#passthru', as: 'new_user_session'
  devise_scope :user do
    get 'sign_in', to: redirect('users/auth/cas')
    get 'sign_out', to: 'devise/sessions#destroy', as: 'destroy_user_session'
  end

  mount Hydra::RoleManagement::Engine => '/'

  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
