# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReceiptGenerator::TaxCalculator do
  let(:calculator) { described_class.new }

  it 'applies 10% basic tax to non-exempt products' do
    product = ReceiptGenerator::Product.new(
      name: 'music CD',
      category: ReceiptGenerator::Category::OTHER
    )
    item = ReceiptGenerator::PurchaseItem.new(product: product, quantity: 1, unit_price: 14.99)

    expect(calculator.tax_for(item)).to eq(1.50)
  end

  it 'applies only import duty for imported exempt products' do
    product = ReceiptGenerator::Product.new(
      name: 'imported box of chocolates',
      category: ReceiptGenerator::Category::FOOD,
      imported: true
    )
    item = ReceiptGenerator::PurchaseItem.new(product: product, quantity: 1, unit_price: 10.00)

    expect(calculator.tax_for(item)).to eq(0.50)
  end

  it 'combines basic sales tax and import duty and rounds up to the nearest 0.05' do
    product = ReceiptGenerator::Product.new(
      name: 'imported bottle of perfume',
      category: ReceiptGenerator::Category::OTHER,
      imported: true
    )
    item = ReceiptGenerator::PurchaseItem.new(product: product, quantity: 1, unit_price: 47.50)

    expect(calculator.tax_for(item)).to eq(7.15)
  end

  it 'rounds partial taxes up to the next nickel' do
    product = ReceiptGenerator::Product.new(
      name: 'imported bottle of perfume',
      category: ReceiptGenerator::Category::FOOD,
      imported: true
    )
    item = ReceiptGenerator::PurchaseItem.new(product: product, quantity: 1, unit_price: 11.25)

    expect(calculator.tax_for(item)).to eq(0.60)
  end
end
