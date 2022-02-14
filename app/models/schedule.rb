class Schedule < ApplicationRecord
  has_many :tutor
  has_many :user
end
