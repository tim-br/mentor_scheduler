class CreateTasConstraintsShiftsTables < ActiveRecord::Migration
  def change
    create_table :mentors do |t|
      t.string :full_name
      t.string :email
      t.timestamps null: false
    end
    create_table :constraints do |t|
      t.integer :mentor_id
      t.integer :day
      t.integer :hour
      t.timestamps null: false
    end
    create_table :shifts do |t|
      t.integer :mentor_id
      t.integer :day
      t.integer :hour
      t.timestamps null: false
    end
  end
end
