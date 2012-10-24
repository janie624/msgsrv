Feature: Visit as Guest
  When guest user visit the site, shows static page.
  User should be able to find sign in link.
  After signed in, will be redirected to home page.
  
    Scenario: Shows static page for guest
      Given I do not have user account
      When I visit the static page
      Then I see the static page
      
    Scenario Outline: Redirect to home page if user signed in
      Given I logged in as <role>
      When I visit the static page
      Then I see the home page
      
      Examples:
        | role    |
        | owner   |
        | admin   |
        | coach   |
        | student |
