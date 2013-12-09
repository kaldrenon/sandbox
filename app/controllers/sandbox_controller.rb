# encoding: UTF-8
require 'tower_data'

#
# Controller for a test environment bed
#
class SandboxController < ApplicationController
  def index
    render 'sandbox'
  end

  def email_validation
    @email = params[:email]

    @tde = TowerData.validate_email(@email)
    @corrections = @tde.corrections
  end
end
