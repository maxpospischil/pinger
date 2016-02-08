require 'httpi'
require 'concurrent'

namespace :ping do

  def while_true_ping_bluefin(url, message)
    while true 
      request = HTTPI::Request.new(url)
      request.headers["Content-Type"] = 'application/json'
      request.auth.ssl.verify_mode = :none  
      http_method = :get
      begin
        result = HTTPI.request(http_method, request, adapter = nil)
        Rails.logger.info({message: message, result: result.body})
      rescue => ex
        Rails.logger.info({message: ex.message})
      end
    end

  end

  desc "Create new data providers if necessary and update existing records with performance data"
  task :bluefin => :environment do
    pool = Concurrent::ThreadPoolExecutor.new(
      min_threads: 200,
      max_threads: 800,
      max_queue: 0,
      fallback: :abort
    )
    2.times do
      pool.post { while_true_ping_bluefin("https://ci-basin-master-two.demystdata.com:9002/api/v1/execute?library_id=2&__ignore_cache=1", "9 vendor benchmark dl's") }
      pool.post { while_true_ping_bluefin("https://ci-basin-master-two.demystdata.com:9002/api/v1/execute?library_id=3&__ignore_cache=1", "2 rng attrs") }
    end
  end

end