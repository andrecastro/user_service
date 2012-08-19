require 'spec_helper'

describe User do
    
    let(:user) { User.new({:name => "Andre Coelho" , :login => "andrecoelho"  , :password => "123456" }) }

    it "is valid with all attributes" do
      user.should be_valid
    end
    
    it "is invalid without login" do
      user.login = nil
      user.should_not be_valid
    end
    
    it "is invalid without password" do
      user.password = nil
      user.should_not be_valid
    end

end
