class FixShortCodeColumnType < ActiveRecord::Migration
  def up
    change_column :short_codes, :shortcode, :text
  end

  def down
    change_column :short_codes, :shortcode, :string
  end
end
