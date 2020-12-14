module TemperatureState::Operation
  class GetForFiveDays < Trailblazer::Operation
    TEMPERATURE_STATES_PER_FIVE_DAYS = 40

    step :validate
    step :get_forecast

    def validate(ctx, params:, **)
      params.is_a?(Hash) && params[:location_id].present?
    end

    def get_forecast(ctx, params:, **)
      location_id = params[:location_id]
      temperature_states = TemperatureState.where(location_id: location_id).where('datetime > ?', Time.now.to_i).all
      if temperature_states.count < TEMPERATURE_STATES_PER_FIVE_DAYS
        WeatherData::Operation::Load.(params: {location_id: location_id})
        temperature_states = TemperatureState.where(location_id: location_id).where('datetime > ?', Time.now.to_i).all
      end
      ctx[:result_collection] = TemperatureState::Representer::StateCollection.represent(temperature_states).to_hash(user_options: {units: params[:units]})
    end
  end
end