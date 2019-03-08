class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.integer :ext_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end