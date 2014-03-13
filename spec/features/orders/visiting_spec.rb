require 'spec_helper'

describe 'Visiting the orders page', js: true do
  describe '-> If I was on this page once before, then it' do
    subject { page }
    let!(:order) {
      create(:order, project_name: 'Foodle', instructions: 'Bake @ 500 degrees C', video_length: '2 Minutes')
    }
    before { page.driver.set_cookie(:order_secure_token, order.secure_token) }
    before { visit '/orders' }

    it { should have_field :order_project_name, with: 'Foodle' }
    it { should have_field :order_instructions, with: 'Bake @ 500 degrees C' }
    it { should have_field :order_video_length, with: '2 Minutes' }
  end
end