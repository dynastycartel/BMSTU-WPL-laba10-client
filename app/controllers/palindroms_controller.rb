# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

# main controller
class PalindromsController < ApplicationController
  include PalindromsHelper
  before_action :validate_input, only: :result
  URL = 'http://localhost:3001/?format=xml'

  def index; end

  def result
    @user_input = params[:user_input].to_i

    redirect_to home_path unless flash.empty?
    return unless flash.empty?

    @side = params[:side]
    my_url = URL + "&user_input=#{@user_input}"
    server_response = URI.open(my_url)
    redirect_to home_path, alert: 'Выберите кнопку' if print_result(@side, server_response).nil?
  end
end
