@javascript @brightgrove
Feature: Aggregate Calendar
  In order to keep an overview about my team's calendar and to find available time
  As an AthleteTrax admin, coach or captain
  I want to view an aggregated calendar

  Step 1—Select Users to Aggregate:
  This works very similarly to how the event or video share works.
  An admin, coach or captain has the ability to pick multiple users
  for an aggregate calendar report.
  The difference is that the user must select the time/times
  and date/dates for when they want to see user's availability. 

  Step 2—Aggregate Calendar Module:
  Once a user has selected the user's calendar they would like to view,
  the application will pull the event categories applicable
  (Athletics, Academics and Extracurriculars.
  Personal events should not be included) and put them into a calendar view.
  The calendar is broken down into 30 minute time slots
  and reports the number of users who are available for each one
  (34/40 users are available). There is also a color coding format
  that highlights the 5 best time slots or the times with the highest
  percentages of users available. The users who have been aggregated
  are listed in the top of the page as well.

  Step 3—Create Event:
  The value for our users behind this feature is to be able to pool a
  large number of users together for the purposes of creating an event
  that involves many users at once.
  There is currently no way for an athletic director or administrator
  to look at a "master calendar" for teams or all freshman or all team
  captains and coaches, so we would like to give our users the ability
  to see when a lot of people are free and then to easily transition
  to creating an event with the people selected for a given time. 

  #
  # This feature file is using tne "Background:" keyword
  # It specifies a set of Givens that will be prepended to all
  #   Scenarios and Outlines in the feature.
  # It is thus a way to be more concise, using the DRY principle
  #   (Don't repeat yourself)
  #
    Background:
      Given the following team members
        | user   | team       | role                     |
        |user1   | testteam1  | Coach                    |
        |user2   | testteam1  | Student-Captain-Freshman |
        |user3   | testteam1  | Student-Senior           |
        |user4   | testteam2  | Coach                    |
        |user5   | testteam2  | Student-Captain-Senior   |
        |user6   | testteam2  | Student-Freshman         |
        |userA   | adminteam1 | Admin                    |
        |userB   | adminteam1 | Admin                    |
      And user2 has event of type "Athletics" on May 17, 2012 from 8:15 AM to 9:45 AM
      And user3 has event of type "Extracurricular" on May 17, 2012 from 11:00 AM to 11:30 AM
      And user5 has event of type "Extracurricular" on May 18, 2012 from 9:00 AM to 10:00 AM
      And user4 has event of type "Academics" on May 17, 2012 from 9:00 AM to 11:00 AM

  Scenario Outline: no aggregate calendar
    When I log in as <aggUser>
      And I have navigated to Calendar

    Then I do not see "Master Calendar" in the menu

    Scenarios:
      | aggUser |
      | user3   |
      | user6   |


  Scenario Outline: Show aggregate calendar
    Given I log in as user1
      And I have navigated to Calendar
      And I have navigated to "Master Calendar" for May, 2012

    When I have added user <addedU1> to aggregation
      And I have added user <addedU2> to aggregation

    Then I <result> in calendar

    Scenarios: For individual users
    | aggUser | addedU1 | addedU2 | result |
    | user1   | user2   |         |see 1 events |
    | user1   | user3   |         |see 1 events |
    | user1   | user2   | user3   |see 2 events |


  Scenario: Break events on 30-minutes blocks
    Given user2 has event of type "Extracurricular" on May 17, 2012 from 10:45 AM to 11:15 AM
      And user2 has event of type "Extracurricular" on May 17, 2012 from 11:15 AM to 11:45 AM
      And I log in as user1
      And I have navigated to Calendar
      And I have navigated to "Master Calendar" for May, 2012

    When I have added user user2 to aggregation
      And I have added user user3 to aggregation

    Then I see 3 events in calendar

  Scenario Outline: Should filter by events by category
    Given user2 has event of type "Academics" on May 16, 2012 from 10:45 AM to 11:15 AM
    And I log in as user1
    And I have navigated to Calendar
    And I have navigated to "Master Calendar" for May, 2012

    When I have added user user2 to aggregation
    And I have added user user3 to aggregation
    And I clicked "<category>"

    Then I see <reaction> in calendar

    Scenarios: For individual users
      | category        | reaction    |
      | All             | 3 event |
      | Athletics       | 1 event |
      | Extracurricular | 1 event |
      | Academics       | 1 event |