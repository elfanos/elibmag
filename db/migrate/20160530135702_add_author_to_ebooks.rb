class AddAuthorToEbooks < ActiveRecord::Migration
  def change
    add_column :ebooks, :author, :string
  end
end
