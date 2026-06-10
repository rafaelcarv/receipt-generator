module ReceiptGenerator
  class ProductClassifier
    class << self
      def category_for(description)
        normalized = description.downcase

        return Category::BOOK if book_product?(normalized)
        return Category::MEDICAL if medical_product?(normalized)
        return Category::FOOD if food_product?(normalized)

        Category::OTHER
      end

      private

      def medical_product?(product_description)
        product_description.match?(
          /headache pills?|pills?|medicine|medication/
        )
      end

      def food_product?(product_description)
        product_description.match?(
          /chocolates?|chocolate bars?|food/
        )
      end

      def book_product?(product_description)
        product_description.match?(
          /books?|novels?|poems?/
        )
      end
    end
  end
end