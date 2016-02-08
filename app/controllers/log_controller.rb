class LogController < ApplicationController

  def download
    send_file(Rails.root.join('log','production.log'))
  end

end