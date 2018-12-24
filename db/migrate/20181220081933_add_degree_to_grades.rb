class AddDegreeToGrades < ActiveRecord::Migration[5.0]
  def change
    add_column :grades, :degree, :string
  end
end
