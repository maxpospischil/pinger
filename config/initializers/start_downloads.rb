def while_true_ping_bluefin(url, message)
  while true 
    request = HTTPI::Request.new(url)
    request.headers["Content-Type"] = 'application/json'
    request.auth.ssl.verify_mode = :none  
    http_method = :get
    begin
      t0 = Time.now
      result = HTTPI.request(http_method, request, adapter = nil)
      elapsed_time = Time.now-t0
      Rails.logger.warn({message: message, elapsed_time: elapsed_time, result: result.body})
    rescue => ex
      Rails.logger.error({message: ex.message})
    end
  end

end

def schedule

  pool = Concurrent::ThreadPoolExecutor.new(
    min_threads: 200,
    max_threads: 800,
    max_queue: 0,
    fallback: :abort
  )

  2.times do
    pool.post { while_true_ping_bluefin("https://ci-basin-master-two.demystdata.com:9002/api/v1/execute?library_id=2&__ignore_cache=1", "9 json blob download attributes") }
    pool.post { while_true_ping_bluefin("https://ci-basin-master-two.demystdata.com:9002/api/v1/execute?library_id=3&__ignore_cache=1", "2 rng attributes") }
  end

end

schedule