class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :member_id
      t.integer :message_id
      t.string :content

      t.timestamps
    end
  end
end
