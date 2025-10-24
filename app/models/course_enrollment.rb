class CourseEnrollment < ApplicationRecord
  self.primary_key = [:course_id, :student_id]

  has_many :enrollment_notes, foreign_key: [:course_id, :student_id], primary_key: [:course_id, :student_id]
end
