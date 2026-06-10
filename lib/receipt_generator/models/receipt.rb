module ReceiptGenerator
  class Receipt
    attr_reader :purchase_items

    def initialize (purchase_items: [])
      @purchase_items = purchase_items
    end

    def add_item(purchase_item)
      purchase_items << purchase_item
    end

    def total
      purchase_items.sum(&:total)
    end

    def sales_taxes
      purchase_items.sum(&:taxes)
    end
  end
end
