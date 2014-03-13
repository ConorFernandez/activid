require 'spec_helper'

describe 'Editing on the orders page', js: true do
  subject { page }
  before { visit '/orders' }
  describe 'The following fields should save after their value changes ->' do
    def test_update(name, value)
      fill_in :"order_#{name}", with: value
      sleep 0.1
      order = Order.first
      expect(order[name]).to eq value
    end
    it('the project name') { test_update(:project_name, 'Tofu Wonders') }
    it('the additional instructions') { test_update :instructions, 'Beat the Heat all Summer Long!' }
    it('the video length') { test_update :video_length, '2 Minutes 45 Seconds' }
  end

end