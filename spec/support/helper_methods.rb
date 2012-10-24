
#def generate_events(user, members)

def members_from(users)
  users.collect{|x| x.id}.join(',')
end

def after_days(now, n)
  (now + n.days).to_date
end

def after_hours(now, n)
  "#{(now + n.hours).strftime('%H:%M:%S')}"
end

=begin
def generate_users
  @users = []
    
  @owner = FactoryGirl.create :owner
  @school1 = FactoryGirl.create :school
  @team1 = FactoryGirl.create :team, school: @school1
  
  @users[0] = FactoryGirl.create :student, school: @school1, team: @team1
  @users[1] = FactoryGirl.create :coach, school: @school1, team: @team1
  @users[2] = FactoryGirl.create :student, school: @school1, team: @team1
  @users[3] = FactoryGirl.create :admin
  
  @team2 = FactoryGirl.create :team, school: @school1
  
  @users[4] = FactoryGirl.create :student, school: @school1, team: @team2
  @users[5] = FactoryGirl.create :coach, school: @school1, team: @team2
  
  @school2 = FactoryGirl.create :school
  
  @team3 = FactoryGirl.create :team, school: @school2
  
  @users[6] = FactoryGirl.create :coach, school: @school2, team: @team3
  @users[7] = FactoryGirl.create :student, school: @school2, team: @team3
end

def generate_events
end

def generate_courses
end

def generate_calendar_events
end
=end