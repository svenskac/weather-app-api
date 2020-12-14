module TemperatureState::Representer
  class StateCollection < Representable::Decorator
    include Representable::Hash::Collection

    items class: TemperatureState, decorator: TemperatureState::Representer::StateWithLocation
  end
end