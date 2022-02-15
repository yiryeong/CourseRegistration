class CreateTutorSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :tutor_schedules do |t|
      t.references :tutor, null: false, foreign_key: true, unique: false
      t.datetime :start_time, null: false
      t.integer :active, null: false

      t.timestamps
    end
  end
end
