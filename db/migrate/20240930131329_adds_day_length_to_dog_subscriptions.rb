class AddsDayLengthToDogSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :dog_subscriptions, :day_length, :integer, default: 0
  end
end
