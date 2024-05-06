class CreateTokens < ActiveRecord::Migration[7.1]
  def change
    create_enum :social_provider, [ "google", "outlook" ]
    create_table :tokens do |t|
      t.integer :user_id, index: true
      t.string :access_token
      t.string :refresh_token
      t.integer :expires_at, index: true
      t.enum :provider, enum_type: "social_provider", default: "google", null: false, index: true

      t.timestamps
    end
  end
end
