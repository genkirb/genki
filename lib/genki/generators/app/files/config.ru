require 'genki'
Dir['./**/*.rb'].each { |file| require file }
app = Genki::Server.new
run app
