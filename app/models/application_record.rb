class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def start_date_should_be_future
    errors.add(:start_time, "is passed time!") if start_time < DateTime.now
  end

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
