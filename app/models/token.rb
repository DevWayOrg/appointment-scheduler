class Token
  attr_accessor :access_token, :refresh_token, :user_id, :expires_at, :id
  private :id=, :user_id=

  def initialize(access_token:, refresh_token:, id:, user_id:, expires_at:)
    self.access_token = access_token
    self.refresh_token = refresh_token
    self.id = id
    self.user_id = user_id
    self.expires_at = expires_at
  end

  def expired?
    expires_at <= Time.now.to_i
  end

  def google_secret
    require "google/api_client/client_secrets"
    secret = {
      "web" => {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "client_id": ENV.fetch("GOOGLE_CLIENT_ID", ""),
        "client_secret" => ENV.fetch("GOOGLE_CLIENT_SECRET", "")
      }
    }
    Google::APIClient::ClientSecrets.new(secret)
  end

  def to_h
    {
      id:,
      access_token:,
      refresh_token:,
      user_id:,
      expires_at:
    }
  end
end
