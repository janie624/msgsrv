Feature: Navigation bar
  Nav bar have to include links availabe against user role.
  
  Scenario Outline: Links on Navigation bar
    Given I logged in as <role>
    Then I see <num> links - <links> on navigation bar
    And I see my name on navigation bar
    
    Examples:
      |role   |num|links                                |
      |owner  |6  |Home,Sign Out,Schools,Teams,Users                          |
      |admin  |8  |Home,Profile,Sign Out,Calendar,Events,Users,News           |
      |coach  |8  |Home,Profile,Sign Out,Calendar,Events,My Team,News         |
      |student|9  |Home,Profile,Sign Out,Calendar,Events,Courses,My Team,News |
