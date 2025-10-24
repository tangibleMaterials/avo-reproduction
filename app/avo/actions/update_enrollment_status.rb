class Avo::Actions::UpdateEnrollmentStatus < Avo::BaseAction
  self.name = "Update Enrollment Status"

  def fields
    field :new_status, as: :select, options: {
      "active" => "Active",
      "completed" => "Completed",
      "withdrawn" => "Withdrawn",
      "pending" => "Pending"
    }
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.update(status: fields[:new_status])
    end

    succeed "Enrollment status updated successfully"
  end
end
