class Tutor < ApplicationRecord
  validates :name, uniqueness: true

  has_many :tutor_schedules
  has_many :schedules
end
