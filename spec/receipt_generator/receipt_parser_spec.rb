# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReceiptGenerator::ReceiptParser do
  let(:parser) { described_class.new }

  it 'raises an error for empty input' do
    expect { parser.call('') }.to raise_error(ArgumentError, 'Input cannot be empty')
  end

  it 'raises an error when input contains only whitespace' do
    expect { parser.call("\n  \n") }.to raise_error(ArgumentError, 'Input cannot be empty')
  end

  it 'raises an error for invalid line format' do
    expect { parser.call('1 invalid line') }.to raise_error(ArgumentError, 'Purchase item price is missing or invalid: 1 invalid line')
  end
end
