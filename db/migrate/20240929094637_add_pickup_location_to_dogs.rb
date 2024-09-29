class AddPickupLocationToDogs < ActiveRecord::Migration[7.1]
  def change
    add_column :dogs, :street_address, :string
    add_column :dogs, :city, :string
    add_column :dogs, :state, :string
    add_column :dogs, :zip_code, :string
    add_column :dogs, :latitude, :float
    add_column :dogs, :longitude, :float
  end
end
