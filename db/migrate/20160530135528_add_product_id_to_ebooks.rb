class AddProductIdToEbooks < ActiveRecord::Migration
  def change
    add_column :ebooks, :productID, :integer
  end
end
