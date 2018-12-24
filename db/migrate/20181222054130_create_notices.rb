class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.text :content

      t.timestamps null: false
    end
  end
end
