class CreateShortcodeData < ActiveRecord::Migration[5.1]

  def change
    create_table :shortcode_data do |t|
      t.string :shortcode
      t.string :url
      t.integer :redirect_count, default: 0
      t.datetime :start_date
      t.datetime :last_seen_date
    end
    add_index(:shortcode_data, :shortcode, unique: true)
  end
end
