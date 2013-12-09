Sandbox::Application.routes.draw do
  root :to => 'sandbox#index'

  resource :sandbox, controller: 'sandbox' do
    post 'email_validation'
  end
end
