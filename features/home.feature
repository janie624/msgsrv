Feature: Home
  An admin, a coach or a student as a identified user 
  Should be able to sign in
  Could see recent news and upcomming events

    Background:
      Given I added news as following:
        | Title               | Source      | Category      | Added date    | Content                     |
        | Test News1          | Espn        | Football      | 2012-09-27    | This is a test news 1       |
        | Test News2          | Espn        | Basketball    | 2012-09-28    | This is a test news 2       |
        | Test News3          | gwsports    | Golf          | 2012-09-29    | This is a test news 3       |
        | Test News4          | Atlantic 10 | Football      | 2012-09-30    | This is a test news 4       |
        | Test News5          | gwsports    | W.Tenis       | 2012-10-01    | This is a test news 5       |
        | Test News6          | gwsports    | M.Soccer      | 2012-10-02    | This is a test news 6       |
        | Test News7          | Espn        |               | 2012-10-03    | This is a test news 7       |
        
    Scenario: Student signs in successfully
      When I logged in as student
      Then I should be on the home page
      Then I should see welcome message
      
    Scenario: Student can see 5 recent news
      When I logged in as student
      Then I should see "Recent News" list as following:
        | No | Title               | Source      | Category      | Added date     | Content                     |
        | 1  | Test News7          | Espn        | General       | Oct. 3th, 2012 | This is a test news 7       |
        | 2  | Test News6          | GW Sports   | M.Soccer      | Oct. 2th, 2012 | This is a test news 6       |
        | 3  | Test News5          | GW Sports   | W.Tenis       | Oct. 1th, 2012 | This is a test news 5       |
        | 4  | Test News4          | Atlantic 10 | Football      | Sep.30th, 2012 | This is a test news 4       |
        | 5  | Test News3          | GW Sports   | Golf          | Sep.29th, 2012 | This is a test news 3       |

    Scenario: Student can see 5 upcoming events
      Given I added test events
      When I logged in as student with id 3
      Then I should see the "Upcoming events" table
