require 'rubygems'
require 'sinatra/base'

require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

require 'haml'
require 'sass'

require 'torquebox'

module Basic
  class Application < Sinatra::Base

    use TorqueBox::Session::ServletStore

    get '/' do
      @posts = Post.all
      haml :index
    end

    post '/posts' do
      # Seriously, don't do this. This app is just a toy
      Post.create(:title=>params[:title], :body=>params[:body], :created_at=>Time.now)
      redirect '/'
    end

    get '/post' do
      haml :new
    end

    get '/post/:id' do
      @post = Post.get(params[:id])
      haml :show
    end

  end
end

class Post

  include DataMapper::Resource

  property :id,         Serial
  property :title ,     String, :required => true, :lazy => false
  property :body   ,    Text, :required => true, :lazy => false
  property :created_at, DateTime

end

DataMapper::Logger.new($stderr, :info)
DataMapper.setup(:default, "sqlite3:basic.db")
DataMapper::Model.raise_on_save_failure = true 
DataMapper.auto_upgrade!
DataMapper.finalize

