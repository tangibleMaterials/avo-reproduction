class Avo::Resources::CourseEnrollment < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :course_id, as: :number
    field :student_id, as: :number
    field :status, as: :text
    field :enrolled_at, as: :date_time
    field :enrollment_notes, as: :has_many
  end

  def actions
    action Avo::Actions::UpdateEnrollmentStatus
  end
end
