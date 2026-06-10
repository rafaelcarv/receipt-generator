# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReceiptGenerator::Category do
  it 'has predefined tax-exempt categories' do
    expect(described_class::BOOK.has_taxes?).to be false
    expect(described_class::FOOD.has_taxes?).to be false
    expect(described_class::MEDICAL.has_taxes?).to be false
  end

  it 'marks other category as taxable' do
    expect(described_class::OTHER.has_taxes?).to be true
  end

  it 'compares categories by name' do
    category_a = described_class.new('food')
    category_b = described_class::FOOD

    expect(category_a).to eq(category_b)
    expect(category_a.hash).to eq(category_b.hash)
  end

  it 'has a string representation equal to its name' do
    expect(described_class::OTHER.to_s).to eq('other')
  end
end
