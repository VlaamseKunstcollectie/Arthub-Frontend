Rails.application.routes.draw do

  concern :exportable, Blacklight::Routes::Exportable.new

  root to: redirect("/#{I18n.default_locale}", status: 302), as: :redirected_root

  get "/404" => "errors#not_found", :via => :all
  get "/422" => "errors#unprocessable_entity", :via => :all
  get "/500" => "errors#internal_server_error", :via => :all

  scope "/:locale", locale: /en|nl/ do
    resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
      concerns :exportable
    end

    resources :bookmarks do
      concerns :exportable

      collection do
        delete 'clear'
      end
    end

    mount Blacklight::Engine => '/'
    root to: "catalog#front"
      concern :searchable, Blacklight::Routes::Searchable.new

    resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog', :constraints => { :id => /[^\/]+/ } do
      concerns :searchable
    end

  #  devise_for :users
  #  concern :exportable, Blacklight::Routes::Exportable.new

    resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog', :constraints => { :id => /[^\/]+/ } do
      concerns :exportable
    end

    resources :bookmarks, :constraints => { :id => /[^\/]+/ } do
      concerns :exportable

      collection do
        delete 'clear'
      end
    end

    mount MiradorRails::Engine, at: MiradorRails::Engine.locales_mount_path

    ALLOW_ANYTHING_BUT_SLASHES = /[^\/]+/

    constraints id: ALLOW_ANYTHING_BUT_SLASHES, rotation: Riiif::Routes::ALLOW_DOTS, size: Riiif::Routes::SIZES do
      get "/iiif/2/:id/:region/:size/:rotation/:quality.:format" => 'riiif/images#show',
        defaults: { format: 'jpg', rotation: '0', region: 'full', size: 'full', quality: 'default', model: 'riiif/image' },
        as: 'riiif_image'

      get "/iiif/2/:id/info.json" => 'riiif/images#info',
        defaults: { format: 'json', model: 'riiif/image' },
        as: 'riiif_info'

      # This doesn't work presently
      get "/iiif/2/:id", to: redirect("/iiif/2/%{id}/info.json"), as: 'riiif_base'
      # get "/iiif/2/:id" => 'riiif/images#redirect', as: 'riiif_base'

      get "iiif/2/:id/manifest.json" => "images#manifest",
        defaults: { format: 'json' },
        as: 'riiif_manifest'
    end

    get "/:id" => "pages#show", :as => :page, :format => false
  
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
