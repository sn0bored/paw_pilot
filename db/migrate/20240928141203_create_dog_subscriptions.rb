class CreateDogSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :dog_subscriptions do |t|
      t.references :dog, null: false, foreign_key: true
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday

      t.timestamps
    end
  end
end
