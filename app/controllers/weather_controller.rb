class WeatherController < ApplicationController

  def locations
    result = TemperatureState::Operation::GetForFiveDays.(params: {location_id: params[:id], units: params[:units]})
    if result.success?
      render json: {cod: 200, message: '', temperature_states: result[:result_collection]}
      return
    end
    render json: {cod: 400, message: 'Operation failed.'}
  end

  def summary
    result = TemperatureState::Operation::GetForNextDay.(params: {location_ids: params[:location_ids], units: params[:units]})
    if result.success?
      render json: {cod: 200, message: '', temperature_states: result[:result_collection]}
      return
    end
    render json: {cod: 400, message: 'Operation failed.'}
  end

  def api
    response = Faraday.get("https://api.openweathermap.org/data/2.5/forecast?q=#{params[:q]}&appid=#{ENV['OPEN_WEATHER_MAPS_API_KEY']}")

    render json: response.body
  end

end
