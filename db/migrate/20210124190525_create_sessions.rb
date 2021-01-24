class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :title
      t.string :comment
      t.timestamp :date
      t.integer :duration

      t.timestamps
    end
  end
end
