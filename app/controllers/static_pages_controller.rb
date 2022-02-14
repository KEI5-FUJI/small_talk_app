class StaticPagesController < ApplicationController
  before_action :not_logged_in_user

  def home
  end
end
