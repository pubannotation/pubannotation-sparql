class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :title
      t.text :sparql
      t.string :graph
      t.text :comment
      t.integer :priority

      t.timestamps
    end
  end
end
