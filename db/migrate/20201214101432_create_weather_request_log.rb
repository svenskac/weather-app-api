class CreateWeatherRequestLog < ActiveRecord::Migration[5.2]
  def change
    create_table :weather_request_logs do |t|
      t.string :location_id, index: true, null: false
      t.string :response_code
      t.text :response_body
      t.timestamps
    end
  end
end
