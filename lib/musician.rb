class Musician < ActiveRecord::Base
  has_many :roles

  validates :name, :instrument, presence: true

  validates :name, :instrument, format: { with: /[a-zA-Z]/,
    message: "This input only allows letters." }
end
