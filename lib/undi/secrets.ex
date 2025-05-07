defmodule Undi.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Undi.Accounts.User, _opts, _context) do
    Application.fetch_env(:undi, :token_signing_secret)
  end
end
