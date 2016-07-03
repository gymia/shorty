class CreateShortcodes < ActiveRecord::Migration
  def change
    create_table :shortcodes do |t|
      t.string   :shortcode
      t.string   :url
      t.integer  :hits, default: 0
      t.timestamps null: false
    end
    add_index :shortcodes, :shortcode
  end
end
