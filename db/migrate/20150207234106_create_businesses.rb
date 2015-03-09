class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.belongs_to :user

      t.timestamps
    end
  end
end