class TutorSchedule < ApplicationRecord
  validates :tutor_id, :start_time, :active, :presence => true
  belongs_to :tutor

  # scope :recent, -> (d) { where("start_time", d.to_datetime.at_beginning_of_week(start_day = :sunday)..d.to_datetime.at_end_of_week(start_day = :sunday) ) }
end
