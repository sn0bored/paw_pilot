class CreateShifts < ActiveRecord::Migration[7.1]
  def change
    create_table :shifts do |t|
      t.date :date
      t.integer :time_of_day

      t.timestamps
    end
  end
end
