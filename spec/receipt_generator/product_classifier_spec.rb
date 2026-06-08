# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReceiptGenerator::ProductClassifier do
  describe '.category_for' do
    it 'classifies book products' do
      expect(described_class.category_for('book')).to eq(ReceiptGenerator::Category::BOOK)
      expect(described_class.category_for('novel')).to eq(ReceiptGenerator::Category::BOOK)
    end

    it 'classifies medical products' do
      expect(described_class.category_for('packet of headache pills')).to eq(ReceiptGenerator::Category::MEDICAL)
      expect(described_class.category_for('medicine')).to eq(ReceiptGenerator::Category::MEDICAL)
    end

    it 'classifies food products' do
      expect(described_class.category_for('box of chocolates')).to eq(ReceiptGenerator::Category::FOOD)
      expect(described_class.category_for('chocolate bars')).to eq(ReceiptGenerator::Category::FOOD)
    end

    it 'classifies products as other when no category matches' do
      expect(described_class.category_for('bottle of perfume')).to eq(ReceiptGenerator::Category::OTHER)
      expect(described_class.category_for('imported bottle of perfume')).to eq(ReceiptGenerator::Category::OTHER)
    end
  end
end
