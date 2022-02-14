class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :tutor, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :lesson_type, null: false
      t.datetime :start_time, null: false

      t.timestamps
    end
  end
end
