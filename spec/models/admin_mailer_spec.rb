require 'spec_helper'


describe AdminMailer do
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
    create :order_file, uploaded_filename: 'Three Sixty Kick Flip.mov', order: order
    create :order_file, uploaded_filename: 'Do What Dance.mp4', order: order
  end
  
  describe '#new_order' do
    subject(:mail) { AdminMailer.new_order(order) }
    its(:to) { should eq ['conor@activid.co'] }
    its(:from) { should eq ['no-reply@activid.co'] }
    its(:subject) { should eq '[ActiVid] New Order' }

    describe 'email body' do
      subject { mail.body.to_s }
      
      it { should include 'Cowboy Coders' }
      it { should include 'Add more cowbell' }
      it { should include 'Steve McQueen' }
      it { should include '1234 Tokyo City' }
      it { should include 'New York' }
      it { should include '90210' }
      it { should include 'steve@gmail.com' }
      it { should include '1-800-US-GOLDMINE' }

      it { should include 'Plan: 1:30-2 Minutes, $95.00' }

      # Uploaded Files
      it { should include 'activid/RANDOM_SECURE_TOKEN/Three Sixty Kick Flip.mov' }
      it { should include 'activid/RANDOM_SECURE_TOKEN/Do What Dance.mp4' }
    end
  end
end
