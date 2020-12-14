module WeatherData::Representer
  class Converter
    KELVIN_ZERO = 273.15

    def self.map_temperatures(temperature_data, units)
      result = temperature_data.deep_dup
      main_data = result['main']
      main_data['temp'] = convert_from_kelvin(main_data['temp'], units)
      main_data['feels_like'] = convert_from_kelvin(main_data['feels_like'], units)
      main_data['temp_min'] = convert_from_kelvin(main_data['temp_min'], units)
      main_data['temp_max'] = convert_from_kelvin(main_data['temp_max'], units)
      result
    end

    def self.convert_from_kelvin(temperature, units)
      case units
      when 'metric' 
        return (temperature - KELVIN_ZERO).round(2)
      when 'imperial' 
        return ((temperature * 9.0/5.0) - 459.67).round(2)
      end
      return temperature
    end
  end
end