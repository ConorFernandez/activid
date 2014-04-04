require 'spec_helper'

describe 'Editing on the orders page', js: true do
  subject { page }
  before { create_expected_video_lengths! }
  before { visit '/orders' }
  let(:four_minute_video) { VideoLength.where(name: '3-4 Minutes').first! }
  describe 'The following fields should save after their value changes ->' do
    def self.test_update(name, text, proc = nil, &block)
      it "should update #{name} to equal #{text}" do
        value = proc ? instance_exec(&proc) : text
        instance_exec value, &block
        wait_for_ajax
        order = Order.last
        expect(order[name]).to eq value
      end
    end
    test_update(:project_name, 'Tofu Wonders') { |v| fill_in :order_project_name, with: v }
    test_update(:instructions, 'Beat the Heat') { |v| fill_in :order_instructions, with: v }
    test_update(:video_length_id, '3-4 Minutes', -> { four_minute_video.id }) do |video_length_id|
      find("#order_video_length_id_#{video_length_id}", visible: false).trigger('click')
    end
  end

  describe 'When trying to upload files ->' do
    it 'I can attach them to my order' do
      attach_file 'file', 'spec/fixtures/cat_in_hat.jpg'
      expect(page).to have_text 'cat_in_hat.jpg'
    end

    it 'I can remove attached files' do
      attach_file 'file', 'spec/fixtures/cat_in_hat.jpg'
      within('.file') do
        click_button 'Remove'
      end
      expect(page).not_to have_text 'cat_in_hat.jpg'
    end

    it 'I can upload attached files' do
      attach_file 'file', 'spec/fixtures/cat_in_hat.jpg'
      click_button 'Start upload'
      wait_for_ajax
      within('.file') do
        expect(page).to have_text 'uploaded!'
      end
    end

  end

  describe 'While uploading files ->' do
    it 'the checkout link should be disabled' do
      start_ajax
      expect(page).to have_css 'a.disabled'
    end

    it 'the checkout link should be enabled after upload is finished' do
      start_ajax
      stop_ajax
      expect(page).not_to have_css 'a.disabled'
    end
  end

  describe 'After editing my order ->' do
    it 'I can move to the checkout page' do
      click_link 'Checkout'
      expect(current_path).to eq '/orders/checkout'
    end
  end

end