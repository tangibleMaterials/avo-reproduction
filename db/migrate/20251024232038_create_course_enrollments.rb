class CreateCourseEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :course_enrollments, primary_key: [:course_id, :student_id] do |t|
      t.integer :course_id
      t.integer :student_id
      t.string :status
      t.datetime :enrolled_at

      t.timestamps
    end
  end
end
