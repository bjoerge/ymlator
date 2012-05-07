class InitialSchema < ActiveRecord::Migration

  def self.up
    create_table :items do |t|
      t.text    :key,   :null => false
      t.text    :name
      t.text    :description
      t.text    :value
      t.timestamps
    end
    add_index :items, :key
  end

  def self.down
    drop_table :items
  end

end
