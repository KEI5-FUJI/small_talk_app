require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation }
    let(:user) {FactoryBot.create(:user)}

    it "有効化メールがちゃんと送れているか" do
      user.activation_token = User.new_token
      mail = UserMailer.account_activation(user)
      expect(mail.subject).to eq "アカウントの有効化"
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ["biolemon.1010@gmail.com"]
      expect(mail.text_part.body.encoded).to match(user.name)
      expect(mail.html_part.body.encoded).to match(user.name)
      expect(mail.text_part.body.encoded).to match(user.activation_token)
      expect(mail.html_part.body.encoded).to match(user.activation_token)
      expect(mail.text_part.body.encoded).to match(CGI.escape(user.email))
      expect(mail.html_part.body.encoded).to match(CGI.escape(user.email))
    end
  end

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
