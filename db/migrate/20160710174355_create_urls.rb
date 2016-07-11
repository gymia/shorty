class CreateUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :urls do |t|
      t.string :url
      t.string :short_code
      t.integer :redirect_count, default: 0

      t.timestamps
    end
  end
end
