class Schedule < ApplicationRecord
  validates :tutor_id, :start_time, :lesson_type, :user_id, presence: true
  validate :start_date_should_be_future
  validates :start_time, uniqueness: {scope: [:start_time, :user_id]}
  belongs_to :tutor
  belongs_to :user
end
