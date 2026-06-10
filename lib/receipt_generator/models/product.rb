module ReceiptGenerator
  class Product
    attr_reader :name, :category, :imported

    def initialize(name:, category:, imported: false)
      @name = name
      @category = category
      @imported = imported
    end

    def imported?
      imported
    end

    def tax_exempt?
      !category.has_taxes?
    end
  end
end
