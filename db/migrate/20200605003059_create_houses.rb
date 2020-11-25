class CreateHouses < ActiveRecord::Migration[6.0]
  def change
    create_table :houses do |t|
      t.integer :bathrooms
      t.integer :bedrooms
      t.float :price
      t.string :address
      t.string :real_state
      t.string :origin_url
      t.string :image

      t.timestamps
    end
  end
end
