def capture(stream)
  begin
    stream = stream.to_s
    eval "@orig_stream = $#{stream}"
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval "$#{stream} = @orig_stream"
  end

  result
end
