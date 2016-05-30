class AddDistributorToEbooks < ActiveRecord::Migration
  def change
    add_column :ebooks, :distributor, :string
  end
end
