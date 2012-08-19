require 'spec_helper'

describe UsersController do
  
  describe "#show" do
    
    it "find an user by id" do
      User.should_receive(:find).with("4f81a908e4b09e3025fe7966")
      get :show , { :id => "4f81a908e4b09e3025fe7966" , :format => :json }
    end
    
    describe "if found" do
      it "return the user as json at the response body"  do
        user = User.create({ :name => "Andre Coelho" , :login => "andrecoelho" , :password => "123456" })
        get :show , { :id => user.id , :format => :json }
        response.body.should == user.to_json
      end
      
    end
    
    describe "if not found" do
      
      it "return 404 error" do
        User.create({ :name => "Andre Coelho" , :login => "andrecoelho" , :password => "123456" })
        get :show , { :id => "id_of_not_found_user" , :format => :json }
        
        response.status.should be_equal(404)
        response.body.gsub(/\s+/, "").should be_empty
      end
      
    end
    
  end
  
  describe "#index" do
    
    before(:each) do
      @user0 = User.create({ :name => "Andre Coelho" , :login => "andrecoelho" , :password => "123456" })
      @user1 = User.create({:name => "Usuario2" , :login => "usuario1", :password => "123456" })
      @user2 = User.create({:name => "Usuario3" , :login => "usuario2", :password => "123456" })
    end
    
    it "returns all users" do
      get :index , { :format => :json }
      users_returned = JSON.parse(response.body)
      users_returned.should == JSON.parse([@user0,@user1,@user2].to_json)
    end
    
  end
  
  describe "#create" do
    
    let(:user) do
      User.new({ :name => "Andre Coelho" , :login => "andrecoelho" , :password => "123456" })
    end
    
    it "create a new user" do
      User.should_receive(:create).with(any_args).and_return(user)
      post :create , {:user => { :name => "Andre Coelho" , :login => "andrecoelho" , :password => "123456" } , :format => :json }
    end
    
    describe "if valid" do
      
      it "return the created user at the response body" do
        User.stub(:create).with(any_args).and_return(user)
        post :create , { :user => { :name => "Andre Coelho" , :login => "andrecoelho" , :password => "123456" } , :format => :json }
        response.status.should be_equal(201)
        attributes = JSON.parse(response.body)
        attributes.delete("_id")
        attributes.should == { "name" => "Andre Coelho" , "login" => "andrecoelho" , "password" => "123456" }
      end
      
      it "return the location of the created user at the header" do
        User.stub(:create).with(any_args).and_return(user)
        post :create , { :user => { :name => "Andre Coelho" , :login => "andrecoelho" , :password => "123456" } , :format => :json }
        response.header["Location"].should_not be_nil
      end
      
    end
    
    describe "if invalid" do
      
      it "return the errors at the response body" do
        post :create , { :user => {  } , :format => :json }
        JSON.parse(response.body)["errors"].should_not be_nil
      end
      
    end
    
  end
  
  describe "#destroy" do
    
    before(:each) { @user = User.create(:name => "User" , :password => "123" ,:login=>"mylogin") }
    
    it "find an user" do
      User.should_receive(:find).with(any_args)
      delete :destroy , { :id => @user.id , :format => :json }
    end
    
    describe "if found" do
      it "delete the user" do
        delete :destroy , { :id => @user.id , :format => :json }
        User.count.should be_equal(0)
      end
      
      it "return a 204 status" do
         delete :destroy , { :id => @user.id , :format => :json }
         response.status.should be_equal(204)
      end
    end
    
    describe "if not found" do
       it "return 404 error" do
         delete :destroy , { :id => "id_of_not_found_user" , :format => :json }
         response.status.should be_equal(404)
       end
    end
    
  end
  
  describe "#update" do
    
    before(:each) { @user = User.create(:name => "User" , :password => "123" ,:login=>"mylogin") }
    
    it "find an user" do
      User.should_receive(:find).with(any_args)
      delete :update , { :id => @user.id , :format => :json }
    end
    
    describe "if found" do
      
      describe "if attributes are valid" do
        
        it "update the user with new attributes" do
          delete :update , { :id => @user.id , :user => { :name => "Andre Coelho"} , :format => :json }
          User.find(@user.id).name.should == "Andre Coelho"
        end
        
        it "return a 204 status" do
          delete :update , { :id => @user.id , :user => { :name => "Andre Coelho"}, :format => :json }
          response.status.should be_equal(204)
        end
        
      end
      
      describe "if attributes are invalid" do
        
        it "return errors at the response body" do
          post :update , { :id => @user.id , :user => { :login => nil  } , :format => :json }
          JSON.parse(response.body)["errors"].should_not be_nil
        end
     
      end
    
    end
    
    describe "if not found" do
       
       it "return 404 error" do
         delete :update , { :id => "id_of_not_found_user" , :user => { :name => "Andre Coelho"} , :format => :json }
         response.status.should be_equal(404)
       end
    
    end
    
  end
  
end