Rails.application.routes.draw do

  devise_for :users
  # :user，跟 resources :users 相比，单数的路由少了 index action，并且网址上不会有 ID，路由方法也皆为单数不需要参数，例如 user_path、edit_user_path。
  # 会这样设计的原因是对前台用户而言，
  # 编辑用户资料就是编辑自己的资料，所以这个单数的用意是指唯一自己，用户也不能修改其他人的资料，因此在controller 里面是写@user = current_user，而不是根据params[:id] 去捞不同用户。
  resource :user

  resources :events do
    resources :registrations do
      member do
        get "steps/1" => "registrations#step1", :as => :step1
        patch "steps/1/update" => "registrations#step1_update", :as => :update_step1
        get "steps/2" => "registrations#step2", :as => :step2
        patch "steps/2/update" => "registrations#step2_update", :as => :update_step2
        get "steps/3" => "registrations#step3", :as => :step3
        patch "steps/3/update" => "registrations#step3_update", :as => :update_step3
      end
    end
  end

  namespace :admin do
    root "events#index"
    resources :events do
      resources :registrations, :controller => "event_registrations"
      resources :tickets, :controller => "event_tickets"
      member do
        post :reorder
      end
      collection do
        post :bulk_update
      end
    end
    resources :users do
      # 因为默认的 controller 的命名是 profiles，这里我们偏好自定义命名改为user_profiles
      resource :profile, controller: "user_profiles" 
    end
  end

  root "events#index"
  get "/faq", to: "pages#faq"

end
