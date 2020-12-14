module TemperatureState::Operation
  class GetForNextDay < Trailblazer::Operation
    TEMPERATURE_STATES_PER_DAY = 8
    step :validate
    step :get_forecast

    def validate(ctx, params:, **)
      if params.is_a?(Hash) && params[:location_ids].present?
        params[:locations] = params[:location_ids].split(',')
      end
      params[:locations].is_a?(Array)
    end

    def get_forecast(ctx, params:, **)
      location_ids = params[:locations]
      location_ids.each do |location_id|
        check_and_load_temperature_for_next_day(location_id)
      end
      temperature_states = get_temperatures_for_next_day(location_ids)
      ctx[:result_collection] = TemperatureState::Representer::StateCollection.represent(temperature_states).to_hash(user_options: {units: params[:units]})
    end

    def check_and_load_temperature_for_next_day(location_id)
      from_time = DateTime.tomorrow.to_time.beginning_of_day.to_i
      to_time = DateTime.tomorrow.to_time.end_of_day.to_i
      temperature_states_count = TemperatureState.where(location_id: location_id).where('datetime >= ? and datetime < ?', from_time, to_time).count
      if temperature_states_count < TEMPERATURE_STATES_PER_DAY
        WeatherData::Operation::Load.(params: {location_id: location_id})
      end
    end

    def get_temperatures_for_next_day(location_ids)
      from_time = DateTime.tomorrow.to_time.beginning_of_day.to_i
      to_time = DateTime.tomorrow.to_time.end_of_day.to_i
      return TemperatureState.where(location_id: location_ids).where('datetime >= ? and datetime < ?', from_time, to_time).all
    end
  end
end