class ReportsController < ApplicationController
  include ApplicationHelper

  def student
    @records = Student.find_by_sql("select bidders.paddle_no
      , people.mailing_label
      , sum(ifnull(purchase_line_items.price*purchase_line_items.quantity,0))/count(distinct ifnull(payments.id,1)) as owed
      , ifnull(check_payments.amount,0) as checks
      , ifnull(cash_payments.amount,0) as cash
      , ifnull(credit_payments.amount,0) as credit
      , ifnull(comp_payments.amount,0) as comp
      , ifnull(prepay_payments.amount,0) as prepay
      , sum(ifnull(purchase_line_items.price*purchase_line_items.quantity,0))/count(distinct ifnull(payments.id,1)) - (ifnull(credit_payments.amount,0)+ifnull(cash_payments.amount,0)+ifnull(check_payments.amount,0)+ifnull(comp_payments.amount,0)+ifnull(prepay_payments.amount,0)) as balance
      from bidders inner join people on bidders.person_id = people.id
      inner join purchases on purchases.bidder_id = bidders.id
      inner join purchase_line_items on purchases.id = purchase_line_items.purchase_id
      left join check_payments on purchases.id = check_payments.purchase_id
      left join cash_payments on purchases.id = cash_payments.purchase_id
      left join credit_payments on purchases.id = credit_payments.purchase_id
      left join comp_payments on purchases.id = comp_payments.purchase_id
      left join prepay_payments on purchases.id = prepay_payments.purchase_id
      left join payments on purchases.id = payments.purchase_id
      where bidders.auction_id = " + session[:auction_id].to_s +
                                      " group by bidders.paddle_no, people.mailing_label
      , ifnull(check_payments.amount,0)
      , ifnull(cash_payments.amount,0)
      , ifnull(credit_payments.amount,0)
      , ifnull(comp_payments.amount,0)
      , ifnull(prepay_payments.amount,0)
      order by bidders.paddle_no")

    respond_to do |format|
      format.html { render(:layout => "layouts/report_layout" ) }
      format.xls {
        require 'iconv'
        converter = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT','UTF-8')
        send_data(converter.iconv(generate_xls(@records, [:paddle_no, :mailing_label, :owed, :checks, :cash, :credit, :comp, :prepay, :balance])),
                  :filename => 'reconciliation.xls',
                  :type => 'application/vnd.ms-excel')
      }
    end

  end
end