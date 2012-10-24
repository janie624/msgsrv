require 'spec_helper'

describe Message do
  it "should be persisted" do
    FactoryGirl.create(:message, :recipients => [FactoryGirl.build(:recipient)]).should be_persisted
  end

  describe "SMS notification" do
    before do
      @message = FactoryGirl.build(:message, :recipients => [FactoryGirl.build(:recipient)], :send_as_text_message => 1)
      SmsMessage.any_instance.stub(:deliver).and_return(true)
    end
    it "should send sms notification if send_as_text_message flag set" do
      @message.should_receive(:send_sms).once
      @message.save!
    end

    it "should validate message length if sms notification enabled" do
      @message.body = '*'*161
      @message.should_not be_valid
    end

    it "should send notification to all recipients" do
      @message.recipients << FactoryGirl.build(:recipient)
      lambda {
        @message.save!
      }.should change(SmsMessage, :count).by(2)
    end

    it "should not allow students to send sms's" do
      student = FactoryGirl.build :student
      message = FactoryGirl.build(:message, :recipients => [FactoryGirl.build(:recipient)], :send_as_text_message => 1, :sender => student)
      message.should_not be_valid
    end
  end


  describe "#destroy" do
    it "should not delete record" do
      recipient = FactoryGirl.create(:recipient)
      message = FactoryGirl.create(:message, :recipients => [recipient])
      lambda {
        message.destroy(recipient.user)
      }.should_not change(Message, :count)

    end
  end

  describe "#recipient_ids=" do
    it "should fill recipients association " do
      recipients = FactoryGirl.create_list(:student, 3)
      excluded_user = FactoryGirl.create(:student)
      message = Message.new
      message.recipient_ids = recipients.map(&:id).join(',')
      message.recipients.map(&:user_id).should == recipients.map(&:id)
    end
  end


end