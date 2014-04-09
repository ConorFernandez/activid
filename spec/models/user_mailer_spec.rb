require 'spec_helper'


describe UserMailer do
  let(:order) {
    create :order,
           project_name: 'Cowboy Coders',
           instructions: 'Add more cowbell',
           cardholder_name: 'Steve McQueen',
           cardholder_address: '1234 Tokyo City',
           cardholder_state: 'New York',
           cardholder_zipcode: '90210',
           cardholder_email: 'steve@gmail.com',
           cardholder_phone_number: '1-800-US-GOLDMINE',
           secure_token: 'RANDOM_SECURE_TOKEN',
           video_length: VideoLength.first # 1:30-2 Minutes, $95.00
  }

  before do
    create_expected_video_lengths!
    create :order_file, original_filename: 'Three Sixty Kick Flip.mov', order: order
    create :order_file, original_filename: 'Do What Dance.mp4', order: order
  end

  describe '#new_order' do
    subject(:mail) { UserMailer.new_order(order) }
    its(:from) { should eq ['no-reply@activid.co'] }
    its(:to) { should eq ['steve@gmail.com'] }
    its(:reply_to) { should eq ['conor@activid.co'] }
    its(:subject) { should eq 'ActiVid order receipt' }

    describe 'email body' do
      subject { mail.body.to_s}

      it { should include 'Purchase: 1:30-2 Minutes, $95.00' }
      it { should include 'Invoice RANDOM_SECURE_TOKEN' }

      # Files uploaded
      it { should include 'Three Sixty Kick Flip.mov' }
      it { should include 'Do What Dance.mp4' }
    end

  end
end
