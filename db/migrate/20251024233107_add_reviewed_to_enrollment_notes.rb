class AddReviewedToEnrollmentNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :enrollment_notes, :reviewed, :boolean, default: false
    add_column :enrollment_notes, :reviewed_at, :datetime
    add_column :enrollment_notes, :reviewed_by, :string
  end
end
