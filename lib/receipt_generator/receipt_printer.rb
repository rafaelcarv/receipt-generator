require_relative "./models/receipt"
require_relative "./models/purchase_item"
require_relative "./models/product"

module ReceiptGenerator
  class ReceiptPrinter
    def initialize(receipt:)
      @receipt = receipt
    end

    def print
      output = ""
      @receipt.purchase_items.each do |item|
        output << "#{item.quantity} #{item.product.name}: #{money(item.total)}\n"
      end
      output << "Sales Taxes: #{money(@receipt.sales_taxes)}\n"
      output << "Total: #{money(@receipt.total)}\n"
      output
    end

    def money(amount)
      format("%.2f", amount)
    end
  end
end