class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.belongs_to :waitlist
      t.belongs_to :user
      t.string :first_name
      t.string :last_name
      t.integer :active, default: 1

      t.timestamps
    end
  end
end
