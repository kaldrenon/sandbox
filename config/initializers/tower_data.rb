require 'tower_data'
require 'yaml'

yml = YAML.load_file(Rails.root.join('config/tower_data.yml'))

TowerData.configure do |c|
  c.token = yml[:token]
  c.auto_accept_corrections = true
  c.timeout = 5
end
