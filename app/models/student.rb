class Student < ApplicationRecord
  has_many :course_enrollments, foreign_key: :student_id
end
