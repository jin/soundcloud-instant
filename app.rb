require 'sinatra'
require 'sinatra/reloader'
require 'soundcloud'
require 'redis'

class SoundCloudInstant < Sinatra::Application

  if Sinatra::Base.development?
    require 'dotenv'
    Dotenv.load
    URL = ENV['DEVELOPMENT_URL']
    redis = Redis.new
  else
    URL = ENV['PRODUCTION_URL']
    redis = Redis.new(:url => ENV['REDISTOGO_URL'])
  end

  configure do
    enable :sessions
    set :session_secret, ENV['SECRET']
    # session[:value] for session id
  end

  get '/' do
    last_track = redis.get("#{session[:value]}.last_track")
    @widget = last_track.nil? ? Client.widget : Client.widget(last_track)
    @url = URL
    erb :index
  end

  post '/' do
    query = params[:q]
    response.headers['Access-Control-Allow-Origin'] = '*'
    Client.search_track(query)
  end
  
  post '/save' do
    redis.set "#{session[:value]}.last_track", params[:uri]
  end

  Client = SoundCloud.new(:client_id => ENV["CLIENT_ID"])
  class << Client

    DEFAULT_TRACK = "https://soundcloud.com/iamtchami/tchami-untrue-extended-mix"

    def search_track(query)
      resp = self.get('/tracks', :q => query)
      resp.first['uri']
    end

    def widget(track_url = DEFAULT_TRACK)
      resp = self.get('/oembed', :url => track_url)
      resp["html"]
    end

  end

end

SoundCloudInstant.run!
