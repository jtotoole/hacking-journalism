class AddKindToComments < ActiveRecord::Migration
  def change
    add_column :comments, :kind, :string
  end
end
