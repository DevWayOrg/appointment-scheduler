class Appointment
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :name, :reason, :date, :time

  attribute :name, :string
  attribute :reason, :string
  attribute :date, :date
  attribute :time, :string
end
