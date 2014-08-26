# encoding: UTF-8
require 'tower_data'

#
# Controller for a test environment bed
#
class SandboxController < ApplicationController
  def index
    @columns = [
      { name: 'S' },
      { name: 'M' },
      { name: 'T' },
      { name: 'W' },
      { name: 'T' },
      { name: 'F' },
      { name: 'S' }
    ]

    @num_cols = @columns.length

    render 'sandbox'
  end

  def email_validation
    @email = params[:email]

    @tde = TowerData.validate_email(@email)
    @corrections = @tde.corrections

    render partial: 'email_validation', layout: false
  end
end
