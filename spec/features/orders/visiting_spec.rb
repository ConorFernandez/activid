require 'spec_helper'

describe 'Visiting the orders page', js: true do
  describe '-> If I was on this page once before, then it' do
    before { create_expected_video_lengths! }
    subject { page }
    let!(:two_minute_video) { VideoLength.where(name: '2-3 Minutes').first! }
    let!(:order) {
      create(:order, project_name: 'Foodle', instructions: 'Bake @ 500 degrees C',
             video_length: two_minute_video)
    }
    before { page.driver.set_cookie(:order_secure_token, order.secure_token) }
    before { visit '/orders' }

    it { should have_field :order_project_name, with: 'Foodle' }
    it { should have_field :order_instructions, with: 'Bake @ 500 degrees C' }
    it { should have_checked_field :"order_video_length_id_#{two_minute_video.id}", visible: false }

    it 'should show me previously attached files' do
      order.order_files.create(original_filename: 'Hot Potato Waltz.mov')
      visit '/orders'
      expect(page).to have_text 'Hot Potato Waltz.mov'
    end

    it 'should not let me delete previously attached files' do
      order.order_files.create(original_filename: 'Hot Potato Waltz.mov')
      visit '/orders'
      within('.attached-files') do
        expect(page).not_to have_button 'Remove'
      end

    end
  end
end