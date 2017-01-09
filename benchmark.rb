def start_benchmark
  start_time = Time.now
  yield
  end_time = Time.now
  p "Completed in #{(end_time - start_time).to_f} seconds"
end
