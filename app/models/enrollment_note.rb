class EnrollmentNote < ApplicationRecord
  belongs_to :course_enrollment, foreign_key: [:course_id, :student_id], primary_key: [:course_id, :student_id]
end
