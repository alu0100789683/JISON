desc "Run server"
task :default => [:use_keys, :jison] do
  sh "rackup"
end

desc "Save config.yml out of the CVS"
task :keep_secrets do
  sh "cp config/config_template.yml config/config.yml "
end

desc "Use the filled client_secrets"
task :use_keys do
  sh "cp config/config_filled.yml config/config.yml"
end

desc "Go to console.developers.google"
task :link do
  sh "open https://console.developers.google.com/project/apps~sinatra-ruby-gplus/apiui/api"
end

desc "Commit changes"
task :ci, [ :message ] => :keep_secrets do |t, args|
  message = args[:message] || ''
  sh "git ci -am '#{message}'"
end

task :jison => %w{public/js/calculator.js} 

desc "Compile the grammar public/calculator.jison"
file "public/js/calculator.js" => %w{public/lib/calculator.jison} do
  sh "rm -f public/js/calculator.js"
  sh "jison public/lib/calculator.jison public/lib/calculator.l -o public/js/calculator.js"
end

desc "Compile the sass public/css/styles.scss"
task :css do
  sh "sass public/css/styles.scss public/css/styles.css"
end

task :testf do
  sh " open -a firefox tests/tests.html"
end

task :tests do
  sh " open -a safari tests/tests.html"
end

desc "Remove calculator.js"
task :clean do
  sh "rm -f public/js/calculator.js"
  sh "rm -f calculator*.tab.jison"
  sh "rm -f calculator*.output"
  sh "rm -f calculator*.vcg"
  sh "rm -f calculator*.c"
end

desc "Open browser in GitHub repo"
task :github do
  sh "open https://github.com/crguezl/ull-etsii-grado-pl-jisoncalc"
end

desc "DFA table using bison -v"
task :table do
  sh "bison -v public/lib/calculator.jison"
end
