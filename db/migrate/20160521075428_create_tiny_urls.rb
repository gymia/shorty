class CreateTinyUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :tiny_urls do |t|
      t.string :url
      t.integer :redirect_count, default: 0
      t.datetime :last_seen_at
      t.string :shortcode, index: :uniq, null: false

      t.timestamps
    end
  end
end
