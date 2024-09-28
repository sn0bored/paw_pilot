class CreateDogSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :dog_schedules do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :shift, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
