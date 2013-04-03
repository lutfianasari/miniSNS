class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :user
      t.string :pass
      t.string :name
      t.string :mail
      t.text :memo
      t.boolean :admin

      t.timestamps
    end
  end
end
