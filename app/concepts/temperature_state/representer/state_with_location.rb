module TemperatureState::Representer
  class StateWithLocation < Representable::Decorator
    include Representable::Hash

    property :location_id
    property :datetime
    property :temperature_data, 
      render_filter: ->(input, options) { WeatherData::Representer::Converter.map_temperatures(input, options[:options][:user_options][:units])}

  end
end