class Avo::Resources::EnrollmentNote < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :course_id, as: :number
    field :student_id, as: :number
    field :course_enrollment, as: :belongs_to
    field :note_text, as: :textarea
    field :created_by, as: :text
    field :reviewed, as: :boolean
    field :reviewed_at, as: :date_time
    field :reviewed_by, as: :text
  end

  def actions
    action Avo::Actions::MarkNoteAsReviewed
  end
end
