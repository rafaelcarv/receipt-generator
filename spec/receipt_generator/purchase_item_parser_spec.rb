# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReceiptGenerator::PurchaseItemParser do
  let(:parser) { described_class.new }

  it 'parses quantity, imported flag, product name and unit price' do
    line = '1 imported bottle of perfume at 27.99'
    item = parser.call(line)

    expect(item.quantity).to eq 1
    expect(item.product.imported?).to be true
    expect(item.product.name).to eq('imported bottle of perfume')
    expect(item.unit_price).to eq(27.99)
    expect(item.product.category).to eq(ReceiptGenerator::Category::OTHER)
  end

  it 'parses non imported exempt products as tax exempt' do
    line = '1 book at 12.49'
    item = parser.call(line)

    expect(item.quantity).to eq 1
    expect(item.product.imported?).to be false
    expect(item.product.category).to eq(ReceiptGenerator::Category::BOOK)
    expect(item.product.tax_exempt?).to be true
  end

  it 'classifies food products correctly' do
    item = parser.call('1 imported box of chocolates at 11.25')

    expect(item.product.category).to eq(ReceiptGenerator::Category::FOOD)
    expect(item.product.imported?).to be true
  end

  it 'classifies medical products correctly' do
    item = parser.call('1 packet of headache pills at 9.75')

    expect(item.product.category).to eq(ReceiptGenerator::Category::MEDICAL)
    expect(item.product.tax_exempt?).to be true
  end

  it 'raises an error for an empty line' do
    expect { parser.call('') }.to raise_error(ArgumentError, 'Purchase item line cannot be empty')
  end

  it 'raises an error when quantity is missing or invalid' do
    expect { parser.call('book at 12.49') }
      .to raise_error(ArgumentError, 'Purchase item quantity is missing or invalid: book at 12.49')
  end

  it 'raises an error when price is missing or invalid' do
    expect { parser.call('1 book at') }
      .to raise_error(ArgumentError, 'Purchase item price is missing or invalid: 1 book at')
  end

  it 'raises an error when description is missing' do
    expect { parser.call('1 at 12.49') }
      .to raise_error(ArgumentError, 'Purchase item description is missing: 1 at 12.49')
  end
end
