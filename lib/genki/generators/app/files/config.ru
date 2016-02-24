require 'genki'
Dir['./**/*.rb'].each { |file| require file }
app = Genki::Application.new
run app
