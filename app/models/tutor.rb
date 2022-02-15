class Tutor < ApplicationRecord
  validates :name, uniqueness: true

  has_many :tutor_schedules, dependent: :destroy
  has_many :schedules, dependent: :destroy
end
