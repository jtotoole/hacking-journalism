class AddGroupToComments < ActiveRecord::Migration
  def change
    add_column :comments, :group, :string
  end
end
