class SearchesController < ApplicationController
  before_action :logged_in_user

  def search
    @user = User.search(params[:keyword])
    render 'search'
  end
end
