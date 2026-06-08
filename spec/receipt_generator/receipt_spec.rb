# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReceiptGenerator::Receipt do
  it 'calculates sales taxes and total across purchase items' do
    book = ReceiptGenerator::Product.new(name: 'book', category: ReceiptGenerator::Category::BOOK)
    perfume = ReceiptGenerator::Product.new(name: 'perfume', category: ReceiptGenerator::Category::OTHER)

    receipt = described_class.new(purchase_items: [
      ReceiptGenerator::PurchaseItem.new(product: book, quantity: 1, unit_price: 12.49),
      ReceiptGenerator::PurchaseItem.new(product: perfume, quantity: 1, unit_price: 14.99)
    ])

    expect(receipt.sales_taxes).to be_within(0.0001).of(1.50)
    expect(receipt.total).to be_within(0.0001).of(28.98)
  end
end
