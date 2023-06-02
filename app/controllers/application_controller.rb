class ApplicationController < ActionController::Base
  def valid_date?(date)
    return true if date.blank?
    Date.parse(date)
  rescue Date::Error
    false
  end
end
