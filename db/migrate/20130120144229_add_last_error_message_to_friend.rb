class AddLastErrorMessageToFriend < ActiveRecord::Migration
  def change
    add_column :friends, :last_error_message, :string
  end
end
