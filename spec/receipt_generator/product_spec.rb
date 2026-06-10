# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReceiptGenerator::Product do
  it 'marks books as tax exempt' do
    product = described_class.new(name: 'book', category: ReceiptGenerator::Category::BOOK)

    expect(product.tax_exempt?).to be true
    expect(product.imported?).to be false
  end

  it 'marks other products as taxable' do
    product = described_class.new(name: 'perfume', category: ReceiptGenerator::Category::OTHER)

    expect(product.tax_exempt?).to be false
  end

  it 'marks food products as tax exempt' do
    product = described_class.new(name: 'box of chocolates', category: ReceiptGenerator::Category::FOOD)

    expect(product.tax_exempt?).to be true
    expect(product.imported?).to be false
  end

  it 'marks imported food products as imported but tax exempt' do
    product = described_class.new(name: 'imported box of chocolates', category: ReceiptGenerator::Category::FOOD, imported: true)

    expect(product.tax_exempt?).to be true
    expect(product.imported?).to be true
  end

  it 'knows when a product is imported' do
    product = described_class.new(name: 'imported perfume', category: ReceiptGenerator::Category::OTHER, imported: true)

    expect(product.imported?).to be true
  end
end
