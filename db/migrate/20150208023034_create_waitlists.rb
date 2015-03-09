class CreateWaitlists < ActiveRecord::Migration
  def change
    create_table :waitlists do |t|
      t.belongs_to :business

      t.timestamps
    end
  end
end
