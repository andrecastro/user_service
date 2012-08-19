require 'cucumber/rspec/doubles'

# GET an user by id as json

  Given /^an user$/ do
    @user = User.new({ :name => "Andre Coelho" , :login => "andrecoelho" , :password => "123456" })
  end

  When /^I acess \/users\/(\w+) with format application\/json$/ do |id|
    User.stub(:find).with(id).and_return(@user)
    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'
    get user_path(id)
  end
  
  Then /^I would like to see the user as json$/ do
    attributes = JSON.parse(last_response.body)
    attributes.delete("_id")
    attributes.should == { "name" => "Andre Coelho" , "login" => "andrecoelho" , "password" => "123456" }
  end

# Try GET an user by id as html

  When /^I acess \/users\/(\w+) with format text\/html$/ do |id|
    header 'Accept', 'text/html'
    header 'Content-Type', 'text/html'
    User.stub(:find).with(id).and_return(@user)
    get user_path(id)
  end
  
  Then /^I would like to see a (\d+) status at response$/ do |status|
    last_response.status.should == status.to_i
  end

# GET all users

  Given /^three users$/ do
    @user1 = User.new({:name => "Andre Coelho" , :login => "andrecoelho", :password => "123456" })
    @user2 = User.new({:name => "Usuario2" , :login => "usuario1", :password => "123456" })
    @user3 = User.new({:name => "Usuario3" , :login => "usuario2", :password => "123456" })
  end
  
  When /^I access \/users with format json$/ do
    User.stub(:all).and_return([@user1,@user2,@user3])
    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'
    get users_path
  end
  
  Then /^I would like to see all users registered as json$/ do
    last_response.status.should == 200
    users = JSON.parse last_response.body
    users.should == JSON.parse([@user1,@user2,@user3].to_json)
  end

# POST an user to create it

  Given /^I want create an user$/ do
  end
  
  When /^I POST the attributes to \/users$/ do
    header 'Accept', 'application/json'
    post users_path , { :user => { :name => "Andre Coelho" , :login => "andrecoelho", :password => "123456" } }
  end
  
  Then /^I would like to create the user$/ do
    last_response.status.should be_equal(201)
    created_user = JSON.parse(last_response.body)
    created_user["name"].should == "Andre Coelho"
  end
  
# Try create an user with errors
  
  Given /^I have an user without login and password$/ do
  end
  
  When /^I POST the invalid user$/ do
    header 'Accept', 'application/json'
    post users_path , { :user => { :name => "Andre Coelho" } }
  end
  
  Then /^I would like to see the validation errors$/ do
    last_response.status.should be_equal(422)
    response_body = JSON.parse(last_response.body)
    response_body["errors"].should_not be_empty
  end
  
# DELETE an user

  Given /^a user registered$/ do
    @user = User.create({:name => "Usuario" , :password => "123456" , :login => "usuario"})
  end
  
  When /^I send a DELETE to \/users\/:id$/ do
    header 'Accept', 'application/json'
    delete user_path(@user.id)
  end
  
  Then /^I would like to delete the user$/ do
    last_response.status.should be_equal(204)
    User.all.should be_empty
  end
  
  
#PUT an user to update attributes

  When /^I PUT new attributes to this user$/ do
    header 'Accept', 'application/json'
    put user_path(@user.id) , { :user => { :name => "Andre Coelho"  } }
  end
  
  Then /^I would like to update the user$/ do
     last_response.status.should be_equal(204)
     header 'Accept', 'application/json'
     get user_path(@user.id)
     new_user = JSON.parse last_response.body
     new_user["name"].should == "Andre Coelho"
  end
  
  
  
  
  
  
