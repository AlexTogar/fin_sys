# frozen_string_literal: true

json.array! @plan_tables, partial: 'plan_tables/plan_table', as: :plan_table
