module WeatherData::Operation
  class Load < Trailblazer::Activity::Railway
    OPEN_WEATHER_MAPS_API_KEY = ENV['OPEN_WEATHER_MAPS_API_KEY']
    OPEN_WEAHTER_MAPS_API_REQUEST_LIMIT = ENV['OPEN_WEAHTER_MAPS_API_REQUEST_LIMIT']

    step :validate
    step :check_limit
    step :load_data

    def validate(ctx, params:, **)
      params.is_a?(Hash) && params[:location_id].present?
    end

    def check_limit(ctx, **)
      WeatherRequestLog.where('created_at > ?', DateTime.now.beginning_of_day).count < OPEN_WEAHTER_MAPS_API_REQUEST_LIMIT.to_i
    end

    def load_data(ctx, params:, **)
      location_id = params[:location_id]
      weather_data = get_parsed_weather_data(location_id)
      unless weather_data.present? and weather_data['list'].present?
        return false
      end
      weather_data['list'].each do |temp_state|
        temperature_state = TemperatureState.find_by(location_id: location_id, datetime: temp_state['dt'])
        unless temperature_state.nil?
          temperature_state.update(temperature_data: temp_state)
          next
        end
        temperature_state = TemperatureState.create(location_id: location_id, datetime: temp_state['dt'], temperature_data: temp_state)
      end
    end

    def get_parsed_weather_data(location_id)
      begin
        response = Faraday.get("https://api.openweathermap.org/data/2.5/forecast?id=#{location_id}&appid=#{OPEN_WEATHER_MAPS_API_KEY}")
        WeatherRequestLog.create(location_id: location_id, response_code: response.status, response_body: response.body)
        weather_data = JSON.parse(response.body)
        return weather_data
      rescue
        return nil
      end 
    end

  end
end