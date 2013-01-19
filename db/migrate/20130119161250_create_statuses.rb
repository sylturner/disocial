class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.text :message

      t.timestamps
    end
  end
end
