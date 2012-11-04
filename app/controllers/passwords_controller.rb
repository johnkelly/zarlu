class PasswordsController < Devise::PasswordsController
  layout :devise, only: :new
end