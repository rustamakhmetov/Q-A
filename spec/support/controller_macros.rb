module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      open_email(@user.email)
      current_email.click_link 'Confirm my account'
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end