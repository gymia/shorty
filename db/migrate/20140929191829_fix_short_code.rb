class FixShortCode < ActiveRecord::Migration
  def change
    rename_column :short_codes, :short_code, :shortcode
  end
end
