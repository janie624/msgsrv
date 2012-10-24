@javascript @brightgrove
Feature: Internal Communication System
  In order to keep my team and colleagues informed and up to date
  As an AthleteTrax user
  I want to send and receive private messages

  Background:
    Given the following team members
      | user   | team      |
      |user1   | testteam1 |
      |user2   | testteam1 |
      |user3   | testteam1 |
      |userA   | testteam2 |
      |userB   | testteam2 |
      |userC   | testteam2 |
      |userD   | testteam2 |



  Scenario Outline: Post to team message board
    Given log in as <postinguser>
      And I have selected "My Team" page from "Main Menu"
      And I have selected "Board" page from "Team Menu"

    When I post the message "tomorrow's session canceled"
      And log off as <postinguser>
      And log in as <readinguser>
      And I have selected "My Team" page from "Main Menu"
      And I have selected "Board" page from "Team Menu"

    Then I see "<reaction>"

  Scenarios: inside testteam1
    |postinguser | readinguser | reaction                     |
    |user1       | user1       | tomorrow's session canceled  |
    |user3       | user2       | tomorrow's session canceled  |
    |user2       | user2       | tomorrow's session canceled  |

  Scenarios: mixed testeams
    |postinguser | readinguser | reaction      |
    |user2       | userB       | There is no board messages yet|
    |userD       | user3       | There is no board messages yet|
    |userA       | user1       | There is no board messages yet|

  Scenarios: inside testteam2
    |postinguser | readinguser | reaction|
    |userA       | userD       | tomorrow's session canceled |
    |userC       | userC       | tomorrow's session canceled |
    |userB       | userA       | tomorrow's session canceled |


  Scenario: View User Directory
    Given I am log in as user3
    And email of user1 is "user1@example.com"
    And email of userB is "userB@example.com"
    And role of user1 is "Student"
    And role of userB is "Coach"
    And name of user1 is "Sam Study"
    And name of userB is "Carl Coach"

    When I navigate to "User Directory"

    Then I see "Sam Study, user1@example.com, testteam1, student"
    And I see "Carl Coach, userb@example.com, testteam2, coach"


  Scenario: Send a message
    Given I log in as user3
      And I have navigated to "Send Message"
      And I have chosen userB as recipient
      And I have entered "Hohoho" as message subject
      And I have entered "good luck!" as message body
      And I have clicked "Send"

    When I log off as user3
      And log in as userB
      And navigate to "Message Inbox"

    Then I see "user3 | Hohoho | good luck!" as my first message in the list


  Scenario: Check sent messages
    Given I am log in as user3
    And I have navigated to "Send Message"
    And I have chosen userB as recipient
    And I have entered "Hohoho" as message subject
    And I have entered "good luck!" as message body
    And I have clicked "Send"

    When I navigate to "Message History, Sent"

    Then I see "userB | Hohoho | good luck!" as my first message in the list


  Scenario Outline: Admin sends message to group
    Given I am log in as userD
      And  role of userD is "Admin"
      And  role of userA is "Student"
      And  role of userB is "Student"
      And  role of userC is "Coach"
      And I have navigated to "Send Message"
      And I have chosen Student as recipient
      And I have entered "Hohoho" as message subject
      And I have entered "good luck!" as message body
      And I have clicked "Send"

    When I log off as userD
      And log in as <user>
      And navigate to "Message Inbox"

    Then I see "<item>" as my first message in the list

  Scenarios: in group
    |user   | item|
    |userA  | userD \| Hohoho \| good luck!|
    |userB  | userD \| Hohoho \| good luck!|

  Scenarios: off group
    |user   | item|
    |userC  ||
    |userD  ||


  Scenario Outline: Affiliate sends message to group
    Given I log in as userD
      And role of userD is "Coach"
      And userD affiliated to testteam2
      And userA affiliated to testteam2
      And userB affiliated to testteam2
      And userC affiliated to testteam1
      And role of userA is "Student"
      And role of userB is "Student"
      And role of userC is "Student"
      And I have navigated to "Send Message"
      And I have chosen Student as recipient
      And I have entered "Hohoho" as message subject
      And I have entered "good luck!" as message body
      And I have clicked "Send"


    When I log off as userD
      And log in as <user>
      And navigate to "Message Inbox"

    Then I see "<item>" as my first message in the list

  Scenarios: in group
    |user   | item|
    |userA  | userD \| Hohoho \| good luck!|
    |userB  | userD \| Hohoho \| good luck!|

  Scenarios: off group
    |user   | item|
    |userC  ||
    |userD  ||

