class Avo::Resources::Student < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :email, as: :text
    field :grade_level, as: :number
    field :course_enrollments, as: :has_many
  end

  def actions
    action Avo::Actions::UpdateGradeLevel
  end
end
