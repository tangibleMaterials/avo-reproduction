class Avo::Actions::MarkNoteAsReviewed < Avo::BaseAction
  self.name = "Mark Note As Reviewed"

  def fields
    field :reviewer_name, as: :text, required: true
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.update(
        reviewed: true,
        reviewed_at: Time.current,
        reviewed_by: fields[:reviewer_name]
      )
    end

    succeed "Notes marked as reviewed successfully"
  end
end
