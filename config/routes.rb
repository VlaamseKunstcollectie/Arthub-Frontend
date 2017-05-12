Rails.application.routes.draw do


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

    get '/:locale' => 'catalog#index'

    mount Blacklight::Engine => '/'
    Blacklight::Marc.add_routes(self)
    root to: "catalog#index"
      concern :searchable, Blacklight::Routes::Searchable.new

  scope "/:locale", locale: /en|nl/ do

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

    Rails.application.routes.draw do
        get "/pages/:page" => "pages#show"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
