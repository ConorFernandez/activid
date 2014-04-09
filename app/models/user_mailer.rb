class UserMailer < ActionMailer::Base
  default from: 'no-reply@activid.co',
          reply_to: 'conor@activid.co'

  def new_order(order)
    @order = order

    mail to: order.cardholder_email, subject: 'ActiVid order receipt'
  end
end