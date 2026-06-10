module ReceiptGenerator
    class Category
    attr_reader :name

    def initialize(name, has_taxes:false)
      @name = name
      @has_taxes = has_taxes
      freeze
    end

    def has_taxes?
      @has_taxes
    end

    def ==(other)
      other.is_a?(Category) && name == other.name
    end
    alias eql? ==

    def hash
      name.hash
    end

    def to_s
      name
    end

    FOOD = new("food")
    BOOK = new("book")
    MEDICAL = new("medical")
    OTHER = new("other", has_taxes: true)
  end
end