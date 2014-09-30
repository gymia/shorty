class AddHitsDefaultValue < ActiveRecord::Migration
  def change
    change_column :short_codes, :hits, :integer, default: 0
  end
end
