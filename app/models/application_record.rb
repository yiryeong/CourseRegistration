class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def start_date_should_be_future
    errors.add(:start_time, "is passed time!") if start_time < DateTime.now
  end
end
