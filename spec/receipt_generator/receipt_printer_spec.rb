# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

RSpec.describe ReceiptGenerator::ReceiptPrinter do
  it 'formats receipt lines with two decimal places and totals' do
    book = ReceiptGenerator::Product.new(name: 'book', category: ReceiptGenerator::Category::BOOK)
    item = ReceiptGenerator::PurchaseItem.new(product: book, quantity: 1, unit_price: 12.49)
    receipt = ReceiptGenerator::Receipt.new(purchase_items: [item])

    output = described_class.new(receipt: receipt).print

    expected_output = <<~OUTPUT
      1 book: 12.49
      Sales Taxes: 0.00
      Total: 12.49
    OUTPUT

    expect(output).to eq(expected_output)
  end
end
