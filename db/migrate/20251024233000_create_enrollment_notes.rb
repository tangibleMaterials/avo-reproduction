class CreateEnrollmentNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollment_notes do |t|
      t.integer :course_id
      t.integer :student_id
      t.text :note_text
      t.string :created_by

      t.timestamps
    end

    add_foreign_key :enrollment_notes, :course_enrollments, column: [:course_id, :student_id], primary_key: [:course_id, :student_id]
  end
end
