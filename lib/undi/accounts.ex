defmodule Undi.Accounts do
  use Ash.Domain, otp_app: :undi, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Undi.Accounts.Token
    resource Undi.Accounts.User
  end
end
