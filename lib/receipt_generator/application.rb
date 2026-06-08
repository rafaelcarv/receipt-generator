require_relative "parsers/receipt_parser"
require_relative "receipt_printer"

module ReceiptGenerator
  class Application
    def initialize(receipt_parser: ReceiptParser.new)
      @receipt_parser = receipt_parser
    end

    def generate(input)
      @receipt_parser.call(input)
    end

    def print(receipt)
      ReceiptPrinter.new(receipt: receipt).print
    end
  end
end