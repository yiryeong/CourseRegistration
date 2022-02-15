class TutorSchedule < ApplicationRecord
  validates :tutor_id, :start_time, :active, :presence => true
  validates :start_time, uniqueness: {scope: [:start_time, :tutor_id]}
  validate :start_date_should_be_future
  belongs_to :tutor

  scope :recent, -> (select_date) { where("start_time >=? AND start_time <=?",
                                          select_date.to_datetime.at_beginning_of_week(start_day = :sunday),
                                          select_date.to_datetime.at_end_of_week(start_day = :sunday) ) }

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
