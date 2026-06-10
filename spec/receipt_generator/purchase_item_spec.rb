# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReceiptGenerator::PurchaseItem do
  let(:product) do
    ReceiptGenerator::Product.new(
      name: 'bottle of perfume',
      category: ReceiptGenerator::Category::OTHER,
      imported: false
    )
  end

  subject(:purchase_item) do
    described_class.new(
      product: product,
      quantity: 2,
      unit_price: 27.99
    )
  end

  describe '#subtotal' do
    it 'returns quantity multiplied by unit price' do
      expect(purchase_item.subtotal).to eq(55.98)
    end
  end

  describe '#unit_taxes' do
    it 'calculates the rounded tax for a single unit' do
      expect(purchase_item.unit_taxes).to eq(2.80)
    end
  end

  describe '#taxes' do
    it 'returns the total tax for the item quantity' do
      expect(purchase_item.taxes).to eq(5.60)
    end
  end

  describe '#total' do
    it 'includes subtotal and total taxes' do
      expect(purchase_item.total).to eq(61.58)
    end
  end
end
