class LogController < ApplicationController

  def download
    send_file(Rails.root.join('log','master.log'))
  end

end