class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :text
      t.string :time
      t.string :position_x
      t.string :position_y

      t.timestamps
    end
  end
end
