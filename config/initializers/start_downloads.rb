class JsonLogger
  @@file_path = Rails.root.join('log', 'master.json')

  def self.log(hash)
    hash = base.merge(hash)
    hash.except(:message).each_value {|v| v.to_s.downcase!}
    # TODO batch the writes to file, when we start making many many logs/s won't be able to open/close it each time
    File.open(@@file_path, 'a') do |file|
      file.write("#{hash.to_json}\n")
    end
  end

  def self.base
    {time: Time.now.to_s}
  end

end


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
      JsonLogger.log({message: message, total_elapsed_time: elapsed_time, result: result.body})
    rescue => ex
      JsonLogger.log({message: ex.message, error:true})
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


  pool.post { while_true_ping_bluefin("https://ci-basin-master-two.demystdata.com:9002/api/v1/execute?library_id=2&__ignore_cache=1", "9 json blob download attributes") }
  #pool.post { while_true_ping_bluefin("https://ci-basin-master-two.demystdata.com:9002/api/v1/execute?library_id=3&__ignore_cache=1", "2 rng attributes") }

end

schedule