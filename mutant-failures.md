# Application#call
* Application does Log StandardErrors
* Application does close the response / responds

# Application#initialize
* It does require files inside app - should have test: ./spec/genki/http/application_spec.rb:21/Genki::Application does call require on files inside ./app

# Controller.delete/options/patch/post/put
* test namespaces
* test block

# Controller.get
* test block

# Controller#cookie_changed?
* do right testing, because it seems as it is no being tested correctly (only tests false/true?)
-  request.cookies[key] != value
+  nil != value
+  self != value
+  request.cookies != value
+  request.cookies.key?(key) != value

# Controller#params
* test pass without 'current'

# Controller#render
* no test for cookies / cookie_changed (almost certain that no test for cookie hasn't changed)

# Controller#render_erb
* no test for context (instance variables mapping)

# Controller#render_text
* no test for text.nil?

# Generators::App.source_root
* Neutral failure (didn't pass unmutated)
  1) Genki::Generators::App.create_sample creates app/home.rb
     Failure/Error: template 'app/home.rb'

     Thor::Error:
       Could not find "app/home.rb" in any of your source paths. Your current source paths are:
       /app/files
     # /Users/diego/.gem/ruby/2.3.1/gems/thor-0.19.1/lib/thor/actions.rb:155:in `find_in_source_paths'

# Generators::App.create_directory
* no test for message directory already exists (content and color)
* no test that created empty directory

# Generators::App#create_sample
* no test that creates 'app' directory

# Generators::App#run_bundle
* no test that it runs 'inside?'
* no test that it runs inside a bundle 'with_clean_env'

Line: 1383
