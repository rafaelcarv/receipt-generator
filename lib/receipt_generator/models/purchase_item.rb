require_relative "../tax_calculator"

module ReceiptGenerator
  class PurchaseItem
    TAX_CALCULATOR = TaxCalculator.new

    attr_reader :product,
                :quantity,
                :unit_price

    def initialize(
      product:,
      quantity:,
      unit_price:
    )
      @product = product
      @quantity = quantity
      @unit_price = unit_price
      @total_with_taxes = nil
      @taxes = nil
    end

    def subtotal
      quantity * unit_price
    end

    def unit_taxes
      TAX_CALCULATOR.tax_for(self)
    end

    def taxes
      @taxes ||= unit_taxes * quantity
    end

    def total
      @total_with_taxes ||= subtotal + taxes
    end
  end
end