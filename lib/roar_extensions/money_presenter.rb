class RoarExtensions::MoneyPresenter
  include RoarExtensions::Presenter

  root_element :money

  delegated_property :cents
  property :currency, :from => :currency_iso_code

  private
  def currency_iso_code
    record.currency.iso_code
  end
end
