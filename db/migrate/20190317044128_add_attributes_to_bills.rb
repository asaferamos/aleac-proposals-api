class AddAttributesToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :title, :string
    add_column :bills, :status, :string
    add_column :bills, :description, :string
  end
end
