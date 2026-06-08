require_relative "purchase_item_parser"
require_relative "../models/receipt"

module ReceiptGenerator
  class ReceiptParser

    def initialize(purchase_item_parser: PurchaseItemParser.new)
      @purchase_item_parser = purchase_item_parser
    end

    def call(input)
      raise ArgumentError, "Input cannot be empty" if input.nil? || input.strip.empty?

      lines = input.lines.map(&:strip).reject(&:empty?)
      raise ArgumentError, "Input contains no purchase items" if lines.empty?

      items = lines.map do |line|
        @purchase_item_parser.call(line)
      end
      Receipt.new(purchase_items: items)
    end
  end
end