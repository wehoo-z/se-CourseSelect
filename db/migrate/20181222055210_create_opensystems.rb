class CreateOpensystems < ActiveRecord::Migration[5.0]
  def change
    create_table :opensystems do |t|
      t.boolean :isopen
      t.timestamps null: false
    end
  end
end
