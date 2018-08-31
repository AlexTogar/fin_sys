# frozen_string_literal: true

json.array! @reasons, partial: 'reasons/reason', as: :reason
