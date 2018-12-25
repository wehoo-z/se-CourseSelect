class CreateDemos < ActiveRecord::Migration[5.2]
  def change
    create_table :demos do |t|
      t.string :title
      t.string :name
      t.string :uptime

      t.timestamps
    end
  end
end
