class User
  include Mongoid::Document
  field :name, type: String
  field :login, type: String
  field :password, type: String

  validates_presence_of :login , :password
  
  def as_json(options={})
    # options[:except].nil? ? options[:except] = [:password] : options[:except] << :password
    super(options).reject { |k, v| v.nil? }
  end
  
end
