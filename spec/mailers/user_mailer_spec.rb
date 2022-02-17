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

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset }
    let(:user) {FactoryBot.create(:user)}

    it "renders the headers" do
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["biolemon.1010@gmail.com"])
      expect(mail.subject).to eq "パスワードリセット"
      expect(mail.html_part.body.decoded).to match(user.reset_token)
      expect(mail.text_part.body.decoded).to match(user.reset_token)
      expect(mail.html_part.body.decoded).to match(CGI.escape(user.email))
      expect(mail.text_part.body.decoded).to match(CGI.escape(user.email))
    end
  end
  

end
