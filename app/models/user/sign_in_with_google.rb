class User::SignInWithGoogle < Solid::Process
  input do
    attribute :name, :string
    attribute :email, :string
    attribute :access_token, :string
    attribute :refresh_token, :string
    attribute :expires_at, :integer

    validates :name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :access_token, presence: true
    validates :expires_at, presence: true

    before_validation do |input|
      input.name = input.name.to_s.strip
      input.email = input.email.to_s.downcase.strip
    end
  end

  deps do
    attribute :repository, default: User::Repository
    attribute :token_repository, default: Token::Repository
  end

  def call(attributes)
    Given(attributes)
      .and_then(:create_or_find_user)
      .and_then(:create_or_update_token)
      .and_expose(:user_registered, %i[user])
  end

  private

  def create_or_find_user(email:, name:, **)
    user = deps.repository.create_or_find_by(email:) do |record|
      record.name = name
    end

    Continue(user:, **)
  end

  def create_or_update_token(user:, access_token:, expires_at:, refresh_token:, **)
    all_tokens_from_user = deps.token_repository.where(user_id: user.id)
    token_record = all_tokens_from_user.find_or_initialize_by(
      provider: 'google'
    )

    token_record.access_token = access_token
    token_record.expires_at = expires_at
    token_record.refresh_token = refresh_token if refresh_token.present?

    token_record.save

    Continue(token: token_record, **)
  end
end
