# frozen_string_literal: true

json.array! @notices, partial: 'notices/notice', as: :notice
