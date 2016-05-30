class AddFormatIdToEbooks < ActiveRecord::Migration
  def change
    add_column :ebooks, :formatGroupId, :integer
  end
end
