class WeatherController < ApplicationController

  def locations
    signal, (ctx, _) = TemperatureState::Operation::GetForFiveDays.(params: {location_id: params[:id], units: params[:units]})
    if signal.success?
      render json: {cod: 200, message: '', temperature_states: ctx[:result_collection]}
      return
    end
    render json: {cod: 400, message: 'Operation failed.'}
  end

  def summary
    signal, (ctx, _) = TemperatureState::Operation::GetForNextDay.(params: {location_ids: params[:location_ids], units: params[:units]})
    if signal.success?
      render json: {cod: 200, message: '', temperature_states: ctx[:result_collection]}
      return
    end
    render json: {cod: 400, message: 'Operation failed.'}
  end

  def api
    response = Faraday.get("https://api.openweathermap.org/data/2.5/forecast?q=#{params[:q]}&appid=#{ENV['OPEN_WEATHER_MAPS_API_KEY']}")

    render json: response.body
  end

end
