class AddUrlToLink < ActiveRecord::Migration
  def change
    add_column :links, :url, :text
    add_index :links, :shortcode
  end
end
