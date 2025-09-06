class CreateTravelTagRelations < ActiveRecord::Migration[7.1]
  def change
    create_table :travel_tag_relations do |t|
      t.references :travel, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
