class SessionsController < Devise::SessionsController
  layout :devise, only: :new
end