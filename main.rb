$:.unshift "."
require 'sinatra'
require "sinatra/reloader" if development?
require 'sinatra/flash'
require 'pl0_program'
require 'auth'
require 'pp'

get '/tests' do
  erb :tests
end

enable :sessions
set :session_secret, '*&(^#234)'
set :reserved_words, %w{grammar test login auth}
set :max_files, 5        # no more than max_files+1 will be saved

helpers do
  def current?(path='/')
    (request.path==path || request.path==path+'/') ? 'class = "current"' : ''
  end
end

get '/grammar' do
  erb :grammar
end

get '/:selected?' do |selected|
  puts "*************@auth*****************"
  puts session[:name]
  pp session[:auth]
  programs = PL0Program.all
  pp programs
  puts "selected = #{selected}"
  c  = PL0Program.first(:name => selected)
  source = if c then c.source else "begin \n\ta = 5*7+9 \nend." end
  erb :index, 
      :locals => { :programs => programs, :source => source }
end

post '/save' do
  pp params
  name = params[:fname]
  if session[:name]
    if settings.reserved_words.include? name  # check it on the client side
      flash[:notice] = 
        %Q{<div class="error">Can't save file with name '#{name}'.</div>}
      redirect back
    else 
      c  = PL0Program.first(:name => name)
      if c
        c.source = params["input"]
        c.save
      else
        if PL0Program.all.size >= settings.max_files
          c = PL0Program.all.sample
          c.destroy
        end
        c = PL0Program.create(
          :name => params["fname"], 
          :source => params["input"])
      end
      flash[:notice] = 
        %Q{<div class="success">File saved as #{c.name} by #{session[:name]}.</div>}
      pp c
      redirect to '/'+name
    end
  else
    flash[:notice] = 
      %Q{<div class="error">You are not authenticated.<br />
         Sign in with Twitter.
         </div>}
    redirect back
  end
end
