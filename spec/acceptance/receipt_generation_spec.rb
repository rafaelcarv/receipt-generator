# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

RSpec.describe 'Receipt generation from fixtures' do
  let(:application) { ReceiptGenerator::Application.new }
  let(:fixtures_root) { File.expand_path('../fixtures', __dir__) }

  def receipt_output_for(fixture_name)
    input = File.read(File.join(fixtures_root, fixture_name))
    receipt = application.generate(input)

    output = StringIO.new
    original_stdout = $stdout
    $stdout = output

    begin
      puts application.print(receipt)
    ensure
      $stdout = original_stdout
    end

    output.string
  end

  it 'generates expected output for example1' do
    expected_output = <<~OUTPUT
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    OUTPUT

    expect(receipt_output_for('example1')).to eq(expected_output)
  end

  it 'generates expected output for example2' do
    expected_output = <<~OUTPUT
      1 imported box of chocolates: 10.50
      1 imported bottle of perfume: 54.65
      Sales Taxes: 7.65
      Total: 65.15
    OUTPUT

    expect(receipt_output_for('example2')).to eq(expected_output)
  end

  it 'generates expected output for example3' do
    expected_output = <<~OUTPUT
      1 imported bottle of perfume: 32.19
      1 bottle of perfume: 20.89
      1 packet of headache pills: 9.75
      3 imported boxes of chocolates: 35.55
      Sales Taxes: 7.90
      Total: 98.38
    OUTPUT

    expect(receipt_output_for('example3')).to eq(expected_output)
  end

  it 'raises a friendly error for an empty input file' do
    input = File.read(File.join(fixtures_root, 'empty_input'))

    expect { application.generate(input) }
      .to raise_error(ArgumentError, 'Input cannot be empty')
  end

  it 'raises a friendly error for malformed data when one bad line is at the bottom' do
    input = File.read(File.join(fixtures_root, 'mixed_valid_and_invalid'))

    expect { application.generate(input) }
      .to raise_error(ArgumentError, 'Purchase item price is missing or invalid: 1 imported bottle of perfume at')
  end

  it 'raises a friendly error for malformed purchase item input' do
    input = File.read(File.join(fixtures_root, 'invalid_purchase_item'))

    expect { application.generate(input) }
      .to raise_error(ArgumentError, 'Purchase item price is missing or invalid: 1 book at')
  end
end
