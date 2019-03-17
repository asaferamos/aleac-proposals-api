class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.integer :ext_id
      t.integer :user_id

      t.timestamps
    end
  end
end