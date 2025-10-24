class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.integer :grade_level

      t.timestamps
    end
  end
end
