@javascript @brightgrove
Feature: Internal Notification System
  In order to keep my team and colleagues informed and up to date
  As an AthleteTrax user
  I want to receive updates from the AthleteTrax application

  Background:
    Given the following team members
      | user  | team      | role    |
      | user1 | testteam1 | Student |
      | user2 | testteam1 | Student |
      | user3 | testteam1 | Student |

  Scenario Outline: shared event notification
    Given User1 has shared the event "Practice" with team testteam1

    When I am log in as <readinguser>
      And I check 1 notifications in the application header

    Then I see "<reaction>"
    
    Scenarios: new event received from user
        | readinguser | reaction |
        | user2       | Practice |
        | user3       | Practice |

  Scenario: User should not receive notifications about own actions
    Given User1 has shared the event "Practice" with team testteam1
    When I am log in as user1
    Then I check 0 notifications in the application header
    
  Scenario Outline: shared event notification
    Given User1 has shared the event "Practice" with team testteam1
      And User1 has change event title from "Practice" to "Workout"

    When I am log in as <readinguser>
      And I check 2 notifications in the application header <readinguser>

    Then I see "<reaction>"

    Scenarios: updated event received from user
        | readinguser | reaction  |
        | user2       | Workout |
        | user3       | Workout |
        
      
  Scenario Outline: shared video notification
    Given User1 has shared the video "Tennis Match" with testteam1

    When I am log in as <readinguser>
      And I check 1 notifications in the application header <readinguser>

    Then I see <reaction>

    Scenarios: New video received from user
        | postinguser | recipient | readinguser | reaction       |
        | user1       | testteam1 | user1       | "Tennis Match" |
        | user1       | testteam1 | user2       | "Tennis Match" |
        | user1       | testteam1 | user3       | "Tennis Match" |  
        
  Scenario Outline: Team Message Board Notification
    Given User1 has posted the message on team board "tomorrow's session canceled"

    When I am log in as <readinguser>
      And I check 1 notifications in the application header <readinguser>
    
    Then I see <reaction>

    Scenarios: New Team Message Board Post
          | readinguser | reaction                      |
          | user2       | "tomorrow's session canceled" |
          | user3       | "tomorrow's session canceled" |


  
    
      
