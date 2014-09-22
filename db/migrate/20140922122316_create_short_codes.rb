class CreateShortCodes < ActiveRecord::Migration
  def change
    create_table :short_codes do |t|
      t.string :short_code
      t.string :url
      t.integer :hits

      t.timestamps
    end
  end
end
