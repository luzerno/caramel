class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.references :program, index: true
      t.time :start_time
      t.time :end_time
      t.string :day_of_week
      t.date :date

      t.timestamps
    end
  end
end
