require 'spec_helper'

describe OrdersController do
  describe 'GET #SHOW' do
    describe 'for users with a order_secure_token cookie' do
      it 'creates a new order' do
        expect {
          get :show
        }.to change{Order.count}
      end

      it 'assigns a new order to @order' do
        get :show
        expect(assigns(:order)).to be_present
      end

      it "writes a cookie called order_secure_token with the value of a new Order's #secure_token" do
        get :show
        expect(cookies[:order_secure_token]).to eq Order.pluck(:secure_token).first
      end
    end

    describe 'for users with an order_secure_token cookie' do
      let!(:order) { create(:order) }
      before { cookies['order_secure_token'] = order.secure_token }

      it 'does not create a new order' do
        expect {
          get :show
        }.not_to change{Order.count}
      end

      it 'assigns an existing order to @order' do
        get :show
        expect(assigns(:order)).to eq order
      end
    end

    describe 'for users with an invalid order_secure_token_cookie' do
      before { cookies['order_secure_token'] = 'forgery!!!!' }

      it 'creates a new order' do
        expect {
          get :show
        }.to change{Order.count}
      end

      it 'assigns the new order to @order' do
        get :show
        expect(assigns(:order)).to be_present
      end

      it 'overwrites the order_secure_token cookie with a valid order token' do
        get :show
        expect(cookies[:order_secure_token]).to eq Order.pluck(:secure_token).first
      end
    end
  end

  describe 'PUT #UPDATE' do
    let!(:order) { create(:order) }
    before { cookies['order_secure_token'] = order.secure_token }

    def test_update(field, value)
      put :update, order: { field => value }
      expect(order.reload[field]).to eq value
    end

    it('updates project name') { test_update :project_name, 'New Project Name' }
    it('updates instructions') { test_update :instructions, 'Fry the fish at 100^, first...' }
    it('updates project length') { test_update :video_length, '2 Minutes' }

    it 'redirects to the /order page if the order_secure_token cookie is invalid' do
      cookies['order_secure_token'] = 'forgery'
      put :update, order: { 'foo' => 'bar' }
      expect(subject).to redirect_to(orders_path)
    end
  end
end