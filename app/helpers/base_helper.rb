# frozen_string_literal: true

module BaseHelper

  def has_family(user_id)
    if family = User.find(user_id).family
      return family #return family id
    else
      return false
    end
  end

  
end
