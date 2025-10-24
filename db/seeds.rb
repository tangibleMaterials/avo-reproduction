# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample students
students = [
  { name: "Alice Johnson", email: "alice@example.com", grade_level: 9 },
  { name: "Bob Smith", email: "bob@example.com", grade_level: 10 },
  { name: "Charlie Brown", email: "charlie@example.com", grade_level: 11 },
  { name: "Diana Prince", email: "diana@example.com", grade_level: 12 }
]

students.each do |student_attrs|
  Student.find_or_create_by!(email: student_attrs[:email]) do |student|
    student.name = student_attrs[:name]
    student.grade_level = student_attrs[:grade_level]
  end
end

puts "Created #{Student.count} students"

# Create sample course enrollments
# Note: For composite primary keys, we need to use create! with the key fields
enrollments = [
  { course_id: 101, student_id: Student.find_by(email: "alice@example.com")&.id, status: "active", enrolled_at: 1.month.ago },
  { course_id: 102, student_id: Student.find_by(email: "alice@example.com")&.id, status: "active", enrolled_at: 1.month.ago },
  { course_id: 101, student_id: Student.find_by(email: "bob@example.com")&.id, status: "active", enrolled_at: 2.weeks.ago },
  { course_id: 103, student_id: Student.find_by(email: "bob@example.com")&.id, status: "completed", enrolled_at: 3.months.ago },
  { course_id: 102, student_id: Student.find_by(email: "charlie@example.com")&.id, status: "active", enrolled_at: 1.week.ago },
  { course_id: 104, student_id: Student.find_by(email: "diana@example.com")&.id, status: "active", enrolled_at: 2.days.ago }
]

enrollments.each do |enrollment_attrs|
  next unless enrollment_attrs[:student_id]

  unless CourseEnrollment.exists?(course_id: enrollment_attrs[:course_id], student_id: enrollment_attrs[:student_id])
    CourseEnrollment.create!(enrollment_attrs)
  end
end

puts "Created #{CourseEnrollment.count} course enrollments"

# Create sample enrollment notes
alice_id = Student.find_by(email: "alice@example.com")&.id
bob_id = Student.find_by(email: "bob@example.com")&.id
charlie_id = Student.find_by(email: "charlie@example.com")&.id

notes = [
  { course_id: 101, student_id: alice_id, note_text: "Student is excelling in this course", created_by: "Prof. Smith" },
  { course_id: 102, student_id: alice_id, note_text: "Needs additional support with advanced topics", created_by: "Prof. Johnson" },
  { course_id: 101, student_id: bob_id, note_text: "Great participation in class discussions", created_by: "Prof. Smith" },
  { course_id: 103, student_id: bob_id, note_text: "Completed all assignments on time", created_by: "Prof. Williams", reviewed: true, reviewed_at: 1.day.ago, reviewed_by: "Dean Anderson" },
  { course_id: 102, student_id: charlie_id, note_text: "Showing steady improvement", created_by: "Prof. Johnson" }
]

notes.each do |note_attrs|
  next unless note_attrs[:student_id]

  unless EnrollmentNote.exists?(course_id: note_attrs[:course_id], student_id: note_attrs[:student_id], note_text: note_attrs[:note_text])
    EnrollmentNote.create!(note_attrs)
  end
end

puts "Created #{EnrollmentNote.count} enrollment notes"
