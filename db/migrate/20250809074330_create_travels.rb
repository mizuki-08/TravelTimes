class CreateTravels < ActiveRecord::Migration[7.1]
  def change
    create_table :travels do |t|
      t.string :title
      t.string :country_name
      t.text :highlight

      t.timestamps
    end
  end
end
