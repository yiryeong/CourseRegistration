class Schedule < ApplicationRecord
  validates :tutor_id, :start_time, :lesson_type, :user_id, presence: true
  belongs_to :tutor
  belongs_to :user

  def get_date
    start_time.strftime("%Y-%m-%d")
  end

  def get_time
    start_time.strftime("%H:%M:%S")
  end

  def get_wday
    start_time .strftime("%a")
  end

  def get_tutor_name
    tutor.name
  end
end
