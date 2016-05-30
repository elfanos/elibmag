class AddDescriptionToEbooks < ActiveRecord::Migration
  def change
    add_column :ebooks, :description, :string
  end
end
