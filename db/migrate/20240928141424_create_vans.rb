class CreateVans < ActiveRecord::Migration[7.1]
  def change
    create_table :vans do |t|
      t.string :name
      t.integer :capacity
      t.references :user

      t.timestamps
    end
  end
end
