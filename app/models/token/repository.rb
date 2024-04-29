class Token::Repository < ApplicationRecord
self.table_name = 'tokens'

  def self.fetch_by(**kwargs)
    token_record = find_by(**kwargs)
    Token.new(
      access_token: token_record.access_token,
      refresh_token: token_record.refresh_token,
      id: token_record.id,
      user_id: token_record.user_id,
      expires_at: token_record.expires_at
    )
  end
end
