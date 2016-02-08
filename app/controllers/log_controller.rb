class LogController < ApplicationController

  def download
    send_file(Rails.root.join('log','master.json'))
  end

end