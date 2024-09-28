class AddDefaultToDogSubscriptionDays < ActiveRecord::Migration[7.1]
  def change
    change_column_default :dog_subscriptions, :monday, false
    change_column_default :dog_subscriptions, :tuesday, false
    change_column_default :dog_subscriptions, :wednesday, false
    change_column_default :dog_subscriptions, :thursday, false
    change_column_default :dog_subscriptions, :friday, false
  end
end
