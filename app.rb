require 'sinatra'
require 'sinatra/reloader'
require 'soundcloud'
require 'redis'
require 'json'

class SoundCloudInstant < Sinatra::Application

  if Sinatra::Base.development?
    require 'dotenv'
    Dotenv.load
    redis = Redis.new
  else
    redis = Redis.new(:url => ENV['REDISTOGO_URL'])
  end

  configure do
    enable :sessions
    set :session_secret, ENV['SECRET']
  end

  get '/' do
    last_track = redis.get("#{session[:session_id]}:last_track")
    @widget = last_track.nil? ? Client.widget : Client.widget(last_track)
    erb :index
  end

  get '/search' do
    query = params[:q]
    response.headers['Access-Control-Allow-Origin'] = '*'
    results = Client.search_track(query)
    results.to_json
  end
  
  post '/save' do
    redis.set "#{session[:session_id]}:last_track", params[:uri]
  end

  Client = SoundCloud.new(:client_id => ENV["CLIENT_ID"])
  class << Client

    DEFAULT_TRACK = "https://soundcloud.com/iamtchami/tchami-untrue-extended-mix"

    def search_track(query)
      resp = self.get('/tracks', :q => query)
      resp.map(&:uri)
    end

    def widget(track_url = DEFAULT_TRACK)
      resp = self.get('/oembed', :url => track_url)
      resp["html"]
    end

  end

end

SoundCloudInstant.run!
