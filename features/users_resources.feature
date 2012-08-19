Feature: Users resources

Scenario: GET an user by id as json
	Given an user
	When I acess /users/4f81a908e4b09e3025fe7966 with format application/json
	Then I would like to see the user as json

Scenario: Try GET an user by id as html
	Given an user
	When I acess /users/4f81a908e4b09e3025fe7966 with format text/html
	Then I would like to see a 406 status at response

Scenario: GET all users
	Given three users
	When I access /users with format json
	Then I would like to see all users registered as json
	
Scenario: POST an user to create it
	Given I want create an user
	When I POST the attributes to /users
	Then I would like to create the user
	
Scenario: Try create an user with errors
	Given I have an user without login and password
	When I POST the invalid user
	Then I would like to see the validation errors
	
Scenario: DELETE an user
	Given a user registered
	When I send a DELETE to /users/:id
	Then I would like to delete the user
	
Scenario: PUT an user to update attributes
	Given a user registered
	When I PUT new attributes to this user
	Then I would like to update the user
