class AddSlugToUrls < ActiveRecord::Migration[5.0]
  def change
    add_column :urls, :slug, :string, unique: true
  end
end
