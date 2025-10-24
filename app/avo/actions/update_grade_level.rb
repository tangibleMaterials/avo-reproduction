class Avo::Actions::UpdateGradeLevel < Avo::BaseAction
  self.name = "Update Grade Level"

  def fields
    field :new_grade_level, as: :number
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.update(grade_level: fields[:new_grade_level])
    end

    succeed "Grade level updated successfully"
  end
end
