# frozen_string_literal: true

json.array! @destinations, partial: 'destinations/destination', as: :destination
