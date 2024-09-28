class AddUserIdToDogSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :dog_schedules, :user_id, :bigint
  end
end
