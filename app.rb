Bundler.require(:default, ENV["RACK_ENV"] || "development")
require "securerandom"
require "base64"

# load models
Dir.glob("models/**/*").each { |f| require_relative f }

class App < Sinatra::Base
  set :database_file, "config/database.yml"
  register Sinatra::ActiveRecordExtension
  configure :development do
    register Sinatra::Reloader
    also_reload "models/**/*"
  end

  get "/" do
    slim :index
  end

  post "/fetch" do
    uuid = SecureRandom.uuid
    TwitterFetcher.fetch(params[:screen_name], uuid)
    redirect "/result/#{Base64Urlsafe.uuid2url(uuid)}"
  end

  get "/result/:id" do
    @id = params[:id]
    slim :result
  end

  get "/cache/:id" do
    filename = "cache/#{Base64Urlsafe.url2uuid(params[:id])}.png"
    send_file filename
  end
end
