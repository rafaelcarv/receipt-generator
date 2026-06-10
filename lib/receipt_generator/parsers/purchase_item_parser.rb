require_relative "../models/purchase_item"
require_relative "../models/product"
require_relative "../category"
require_relative "../classifiers/product_classifier"

module ReceiptGenerator
  class PurchaseItemParser
    PATTERN = /\A
               (?<quantity>\d+)
               \s+
               (?<description>.+)
               \s+
               at
               \s+
               (?<price>\d+\.\d{2})
               \z/x
    QUANTITY_PATTERN = /\A\d+\b/
    PRICE_PATTERN = /\sat\s+\d+\.\d{2}\z/
    DESCRIPTION_PATTERN = /\A\d+\s+.+\s+at\s+\d+\.\d{2}\z/
    def call(line)
      cleaned_line = line.to_s.strip
      validate_line!(cleaned_line)

      match = PATTERN.match(cleaned_line)
      description = match[:description]
      PurchaseItem.new(
        quantity: match[:quantity].to_i,
        unit_price: match[:price].to_f,
        product: build_product(description)
      )
    end

    private

    def validate_line!(line)
      raise ArgumentError, "Purchase item line cannot be empty" if line.empty?
      raise ArgumentError, "Purchase item quantity is missing or invalid: #{line}" unless line.match?(QUANTITY_PATTERN)
      raise ArgumentError, "Purchase item price is missing or invalid: #{line}" unless line.match?(PRICE_PATTERN)
      raise ArgumentError, "Purchase item description is missing: #{line}" unless line.match?(DESCRIPTION_PATTERN)
    end

    def build_product(description)
      Product.new(
        name: description,
        category: ProductClassifier.category_for(description),
        imported: imported?(description)
      )
    end

    def imported?(description)
      description.include?("imported")
    end
  end
end