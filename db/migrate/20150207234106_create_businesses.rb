class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.belongs_to :user
      t.integer :current_waitlist_id
      t.boolean :open, default: false
      t.string :slug

      t.timestamps
    end
  end
end