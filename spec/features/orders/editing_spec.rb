require 'spec_helper'

describe 'Editing on the orders page', js: true do
  subject { page }
  before { visit '/orders' }
  describe 'The following fields should save after their value changes ->' do
    def self.test_update(name, value, &block)
      it "should update #{name} to equal #{value}" do
        instance_exec value, &block
        wait_for_ajax
        order = Order.last
        expect(order[name]).to eq value
      end
    end
    test_update(:project_name, 'Tofu Wonders') { |v| fill_in :order_project_name, with: v }
    test_update(:instructions, 'Beat the Heat') { |v| fill_in :order_instructions, with: v }
    test_update(:video_length, '4 Minutes') { |v| choose(v) }
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

  describe 'After editing my order ->' do
    it 'I can move to the checkout page' do
      click_link 'Checkout'
      expect(current_path).to eq '/orders/checkout'
    end
  end

end