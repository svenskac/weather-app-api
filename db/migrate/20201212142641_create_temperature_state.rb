class CreateTemperatureState < ActiveRecord::Migration[5.2]
  def change
    create_table :temperature_states do |t|
      t.integer :location_id, index: true, null: false
      t.text :temperature_data, null: false
      t.integer :datetime, null: false, index: true
      t.timestamps
    end
  end
end
