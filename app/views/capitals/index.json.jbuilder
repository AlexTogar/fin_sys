# frozen_string_literal: true

json.array! @capitals, partial: 'capitals/capital', as: :capital
