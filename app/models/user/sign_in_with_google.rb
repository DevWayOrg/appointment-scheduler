class User::SignInWithGoogle < Solid::Process
  input do
    attribute :name, :string
    attribute :email, :string

    validates :name, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    before_validation do |input|
      input.name = input.name.to_s.strip
      input.email = input.email.to_s.downcase.strip
    end
  end

  deps do
    attribute :repository, default: User::Repository
  end

  def call(attributes)
    Given(attributes)
      .and_then(:create_or_find_user)
  end

  private

  def create_or_find_user(email:, name:)
    user = deps.repository.create_or_find_by(email:) do |record|
      record.name = name
    end

    Success(:user_registered, user:)
  end
end
