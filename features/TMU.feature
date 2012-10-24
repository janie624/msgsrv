@brightgrove
Feature: Text Message Updates
	In order to keep my team and colleagues informed and up to date
	As an AthleteTrax user
	I want to send and receive text messages

  Background:
    Given the following team members
      | user   | team       |
      |user1   | testteam1  |
      |user2   | testteam1  |
      |user3   | testteam1  |
      |user4   | testteam2  |
      |user5   | testteam3  |
      |user6   | testteam2  |
      |userA   | adminteam1 |
      |userB   | adminteam1 |

  Scenario Outline: Send message as text message update
		Given I am log in as <postinguser>
		And role of user1 is "Coach"
		And role of user2 is "Student-Captain-Freshman"
		And role of user3 is "Student-Senior"
		And role of user4 is "Coach"
		And role of user5 is "Student-Captain—Senior"
		And role of user6 is "Student-Freshman"
		And role of userA is "Admin"
		And role of UserB is "Admin"
		And I have navigated to "Send Message"
		And I have entered "<recipient>" as message recipient_names
		And I have entered "tomorrow's athletics cancelled" as message body
		And I have checked the "send as text message" checkbox
		And I have clicked "Send" button

		When I have check my text messages in the cellphone of <readinguser>

		Then I see <reaction>


	Scenarios: Admin Sends text message to user
		| postinguser | recipient | readinguser | reaction                         |
		| userA       | user3     | user1       | ""                               |
		| userA       | user3     | user3       | "tomorrow's athletics cancelled" |
		| userA       | user3     | user6       | ""                               |

	Scenarios: Admin sends text message to team
		| postinguser | recipient | readinguser | reaction                         |
		| userA       | testteam1 | user1       | "tomorrow's athletics cancelled" |
		| userA       | testteam1 | user2       | "tomorrow's athletics cancelled" |
		| userA       | testteam1 | user3       | "tomorrow's athletics cancelled" |
		| userA       | testteam1 | user4       | ""                               |
		| userA       | testteam1 | user5       | ""                               |
		| userA       | testteam1 | user6       | ""                               |
		
	Scenarios: Admin sends text message to captains
		| postinguser | recipient | readinguser | reaction                         |
		| userA       | Captains  | user1       | ""                               |
		| userA       | Captains  | user2       | "tomorrow's athletics cancelled" |
		| userA       | Captains  | user3       | ""                               |
		| userA       | Captains  | user4       | ""                               |
		| userA       | Captains  | user5       | "tomorrow's athletics cancelled" |
		| userA       | Captains  | user6       | ""                               |
		
	Scenarios: Admin sends text message to all users
		| postinguser | recipient | readinguser | reaction
		| userA       | AllUsers  | user1       | "tomorrow's athletics cancelled" |
		| userA       | AllUsers  | user2       | "tomorrow's athletics cancelled" |
		| userA       | AllUsers  | userB       | "tomorrow's athletics cancelled" |
		| userA       | AllUsers  | userA       | ""                               |
		
	Scenarios: Coach sends text message to team member
		| postinguser | recipient | readinguser | reaction                         |
		| user1       | user2     | user1       | ""                               |
		| user1       | user2     | user2       | "tomorrow's athletics cancelled" |
		| user1       | user2     | user3       | ""                               |
		
	Scenarios: Coach sends text message to team captains
		| postinguser | recipient | readinguser | reaction                         |
		| user1       | Captains  | user2       | "tomorrow's athletics cancelled" |
		| user1       | Captains  | user3       | ""                               |
		| user4       | Captains  | user5	      | "tomorrow's athletics cancelled" |
		| user4       | Captains  | user6	      | ""                               |
		
	Scenarios: Coach sends text message to team freshmen 
		| postinguser | recipient | readinguser | reaction
		| user1       | Freshmen  | user2       | "tomorrow's athletics cancelled" |
		| user1       | Freshmen  | user3       | ""                               |
		| user4       | Freshmen  | user5		    | ""                               |
		| user4       | Freshmen  | user6		    | "tomorrow's athletics cancelled" |

	Scenarios: Coach sends text message to team
		| postinguser | recipient | readinguser | reaction                         |
		| user1       | Team      | user1       | ""                               |
		| user1       | Team      | user2       | "tomorrow's athletics cancelled" |
		| user1       | Team      | user3       | "tomorrow's athletics cancelled" |
		| user4       | Team      | user4       | ""                               |
		| user4       | Team      | user5       | "tomorrow's athletics cancelled" |
		| user4       | Team      | user6       | "tomorrow's athletics cancelled" |
		
	Scenarios: Captain sends text message to team member
		| postinguser | recipient | readinguser | reaction                         |
		| user2       | user1     | user1       | "tomorrow's athletics cancelled" |
		| user2       | user1     | user2       | ""                               |
		| user2       | user1     | user3       | ""                               |

	Scenarios: Captain sends text message to team freshman 
		| postinguser | recipient | readinguser | reaction                         |
		| user2       | user6     | user2       | ""                               |
		| user4       | user6     | user6		    | "tomorrow's athletics cancelled" |

	Scenarios: Captain sends text message to team
		| postinguser | recipient | readinguser | reaction                         |
		| user2       | Team      | user1       | "tomorrow's athletics cancelled" |
		| user2       | Team      | user2       | ""                               |
		| user2       | Team      | user3       | "tomorrow's athletics cancelled" |
		| user5       | Team      | user4       | "tomorrow's athletics cancelled" |
		| user5       | Team      | user5       | ""                               |
		| user5       | Team      | user6       | "tomorrow's athletics cancelled" |


	Scenario: Students Cannot Send Text Messages

		Given I am log in as user1
		And role of user1 is "Student-Senior" 
		
		When I navigate to "Send Message"

		Then I do not see the "send as text message" checkbox


	Scenario: Users do not receive text messages sent from themselves

		Given I am logged in as user1
		And I have navigated to "Send Message"
		And I have checked the "send as text message" checkbox
		And I have entered "tomorrow's athletics cancelled" as message body
		And I have entered "user1" as recipient
		And I have clicked the "Send" button
		
		When I check my text messages

		Then I see no new text message
