# http://datamapper.org/docs/properties.html
# Note default validations in settings.rb

class Handler
  include DataMapper::Resource
  attr_accessor :k # for storing a handler instance's position
                   # in the HandlerPair hash

  property :id,               Serial
  property :name,             String,   :unique => true
  property :request,          String
  property :score,            Integer,  :default => 0
  property :positive,         Integer,  :default => 0
  property :negative,         Integer,  :default => 0
  property :ranked_searches,  Integer,  :default => 0
  property :active,           Boolean,  :default => true
  property :created_at,       DateTime
  
    
  def won(i)
    self.attributes = {
      :score => self.score + i.to_i,
      :positive => self.positive + 1,
      :ranked_searches => self.ranked_searches + 1
    }
  end
  
  
  def lost
    self.attributes = {
      :negative => self.negative + 1,
      :ranked_searches => self.ranked_searches + 1
    }
  end
  
  
  def self.any_two
    h = HandlerPair.new
    a = Handler.all
    a.shuffle!
    h[:a] = a.pop
    h[:b] = a.pop
    if h.has_value? nil
      nil
    else
      h
    end
  end


  def self.any_two_safely
    h = Handler.any_two
    if h == nil
      flash[:error] = error_text[:no_handlers]
      redirect '/'
    else
      h
    end
  end
  
  
  def self.get_pair(a, b)
    h = HandlerPair.new
    h[:a] = Handler.first(:id => a)
    h[:b] = Handler.first(:id => b)
    if h.has_value? nil
      nil
    else
      h
    end
  end
  
  
  def self.get_pair_safely(a, b)
    h = Handler.get_pair(a, b)
    if h == nil
      flash[:error] = error_text[:missing_handler]
      redirect '/'
    else
      h
    end
  end
end
