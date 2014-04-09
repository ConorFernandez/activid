class AdminMailer < ActionMailer::Base
  default from: 'no-reply@activid.co'

  def new_order(order)
    @order = order

    mail to: 'conor@activid.co', subject: '[ActiVid] New Order'
  end
end