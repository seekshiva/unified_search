class CreateMusics < ActiveRecord::Migration
  def self.up
    create_table :musics do |t|
      t.string :sha1_sum
      t.string :file
      t.string :title
      t.string :album
      t.string :artist
      t.integer :year
      t.string :genre
      t.string :duration
      t.string :mime_type, :length => 6
      t.string :thumbnail
      
      
      t.timestamps
    end
  end

  def self.down
    drop_table :musics
  end
end
