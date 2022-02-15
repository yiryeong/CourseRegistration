class Schedule < ApplicationRecord
  validates :tutor_id, :start_time, :lesson_type, :user_id, presence: true
  belongs_to :tutor
  belongs_to :user
end
