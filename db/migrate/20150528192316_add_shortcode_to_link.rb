class AddShortcodeToLink < ActiveRecord::Migration
  def change
    add_column :links, :shortcode, :string, :default => nil
  end
end
