class CreateRequirements < ActiveRecord::Migration[8.0]
  def change
    create_table :requirements do |t|
      t.references :user, null: false, foreign_key: true
      t.text :values

      t.timestamps
    end
  end
end
