module ReceiptGenerator
  class TaxCalculator
    BASIC_TAX = 0.10
    IMPORT_DUTY = 0.05
    ROUNDING_INCREMENT = 0.05

    def tax_for(item)
      tax = 0.0
      tax += item.unit_price * BASIC_TAX if item.product.category.has_taxes?
      tax += item.unit_price * IMPORT_DUTY if item.product.imported?
      round_to_nearest_nickel(tax)
    end

    def round_to_nearest_nickel(number)
      ((number / ROUNDING_INCREMENT).ceil * ROUNDING_INCREMENT).round(2)
    end
  end
end