# Receipt Generator

A Ruby application for generating and printing receipts from a shopping basket.

## Overview

This application parses a shopping basket, calculates applicable taxes, and prints a receipt containing:

* Item prices including taxes
* Total sales taxes
* Overall total

The solution was implemented using plain Ruby without application frameworks, following object-oriented design principles and keeping responsibilities separated into small, focused classes.

## Requirements

* Ruby 3.x
* Bundler

## Installation

Clone the repository:

```bash
git clone https://github.com/rafaelcarv/receipt-generator.git
cd receipt-generator
```

Install dependencies:

```bash
bundle install
```

The dependencies are required just to be able to run the RSpec tests. For the main application it is not required to install any dependency.

## Running the Application

Create an input file containing the shopping basket. Each input line must have the following pattern:
`<quantity> <item description> at <price as a decimal with two digits>`
If a line does not follow this pattern, the application will stop and show an error message. More details about error handling are shown in the [Error Handling](#error-handling) section.

Example:

```text
1 imported bottle of perfume at 27.99
1 bottle of perfume at 18.99
1 packet of headache pills at 9.75
3 imported boxes of chocolates at 11.25
```

Save it as a file:

```text 
input.txt
```

Run the application:

```bash
bin/receipt-generator input.txt
```

or 

```bash
ruby bin/receipt-generator input.txt
```

You can also pipe input into the application:

```bash
cat input.txt | ruby bin/receipt-generator
```

The application will output to stdout.
Output example:

```text
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported boxes of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```

## Error Handling

The application validates both the raw input and each purchase item line.

If the overall input file is empty or contains only whitespace, the application raises:

* `ArgumentError: Input cannot be empty`

If the file contains no valid purchase item lines, it raises:

* `ArgumentError: Input contains no purchase items`

Each purchase item line is also validated before parsing. Invalid lines raise a friendly error with one of these messages, including the offending line content:

* `Purchase item line cannot be empty: ""`
* `Purchase item quantity is missing or invalid: book at 12.49`
* `Purchase item description is missing: 1 at 12.49`
* `Purchase item price is missing or invalid: 1 book at`

This ensures malformed input is detected early and the application fails fast with a meaningful error.

## Running the Test Suite

Execute all tests:

```bash
bundle exec rspec
```

This executes both unit and acceptance tests.

## Design

The application follows a simple object-oriented design where each class has a single responsibility.

### Core Flow

The system works in a single pass from raw input text to printed receipt:

```text
Input File
    ↓
ReceiptParser
    ↓
PurchaseItemParser
    ↓
ProductClassifier
    ↓
PurchaseItem / Product
    ↓
Receipt
    ↓
ReceiptPrinter
    ↓
Output
```

The `Application` loads the input and passes it to `ReceiptParser`.
The `ReceiptParser` splits the text into lines, parses each line with `PurchaseItemParser`, and collects the resulting items into a `Receipt`.

`PurchaseItemParser` extracts quantity, description, and price from each line. It delegates the product categorization to the ProductClassifier passing the description to it, builds a `Product` instance, and creates a `PurchaseItem` with the product, unit price, and quantity.

Once all items are assembled, the `Receipt` calculates totals and sales taxes. `ReceiptPrinter` then formats the receipt lines and totals for output.

### Main Components

#### Application

Application entry point responsible for orchestrating the receipt generation process.

#### ReceiptParser

Parses the raw input and builds a Receipt containing multiple purchase items.

#### PurchaseItemParser

Parses individual lines such as:

```text
1 imported bottle of perfume at 27.99
```

and converts them into a `Product` and `PurchaseItem`. It delegates the product classification to the ProductClassifier.

#### ProductClassifier

Products are classified using keyword matching against the product description. The current classifier keywords are grouped by category:

* **Food**: `chocolate`, `chocolates`, `chocolate bar`, `chocolate bars`, `food`
* **Book**: `book`, `books`, `novel`, `novels`, `poem`, `poems`
* **Medical**: `headache pill`, `headache pills`, `pill`, `pills`, `medicine`, `medication`

These keyword examples are intentionally illustrative: they show how to extend the classifier by adding new words or phrases to the relevant category.

Products that do not match a known category are classified as `Other`.

#### PurchaseItem

Represents a purchased product.

Responsible for:

* Quantity
* Unit price
* Item subtotal
* Item taxes
* Item total (subtotal + taxes)

Tax calculation is delegated to `TaxCalculator`.

#### TaxCalculator

Encapsulates all tax calculation rules.

Current rules:

* Basic sales tax: 10%
* Import duty: 5%
* Tax rounded up to the nearest 0.05

#### Receipt

Represents a collection of purchased items and provides aggregate calculations:

* Total sales taxes
* Receipt total

#### ReceiptPrinter

Formats a Receipt into the final output expected by the challenge.

## Tax Rules

### Basic Sales Tax

Applied at 10% to all products except:

* Books
* Food
* Medical products

### Import Duty

Applied at 5% to all imported products.

### Rounding

Taxes are rounded up to the nearest 0.05.

Examples:

```text
0.5625 → 0.60
1.4990 → 1.50
4.1985 → 4.20
```

## Assumptions

### Tax Calculation Per Unit

Taxes are calculated and rounded at the individual item level before being multiplied by quantity.

This behavior was chosen because it matches the expected output provided in the challenge specification.

Example:

```text
3 imported boxes of chocolates at 11.25
```

Unit tax:

```text
11.25 × 5% = 0.5625
0.5625 → 0.60
```

Total tax:

```text
0.60 × 3 = 1.80
```

Result:

```text
35.55
```

which matches the expected output.

### Monetary Calculations

The application uses native floats for monetary calculations and formats values to two decimal places when printing the final receipt output.

Formatting to two decimal places is only performed when generating the final receipt output.

## Project Structure

```text
lib/
├── receipt_generator.rb
└── receipt_generator/
    ├── application.rb
    ├── tax_calculator.rb
    ├── receipt_printer.rb
    ├── category.rb
    │
    ├── classifiers/
    │   ├── product_classifier.rb
    │
    ├── models/
    │   ├── product.rb
    │   ├── purchase_item.rb
    │   └── receipt.rb
    │
    └── parsers/
        ├── purchase_item_parser.rb
        └── receipt_parser.rb
```

## Testing Strategy

The test suite is organized into multiple levels:

### Unit Tests

Verify individual classes and behavior in isolation:

* `Category`
* `Product`
* `ProductClassifier`
* `PurchaseItemParser`
* `TaxCalculator`
* `PurchaseItem`
* `Receipt`
* `ReceiptPrinter`

### Acceptance Tests

Verify the complete end-to-end flow from example input fixtures to printed receipt output.

The acceptance tests exercise the full application stack and ensure the generated receipt matches the expected example outputs exactly.

## Design Principles

The implementation focuses on:

* Separation of responsibilities
* Single Responsibility Principle
* Explicit domain modeling
* Testability through isolated components
* Minimal dependencies
* Readable and maintainable code

The goal was to provide a solution that is easy to understand, easy to test, and straightforward to extend without introducing unnecessary complexity.

## Future Improvements

Potential enhancements for the application:

* Improved product categorization
  - Replace the current regex-based classifier with a more robust strategy or external lookup to reduce false positives and simplify maintenance.
* Dedicated Money value object
  - Encapsulate rounding, formatting, and currency behavior in a single domain object rather than handling it directly in the calculator and printer.
* Configurable tax rules
  - Allow tax rates and exemption rules to be defined through configuration, making the app easier to adapt to different business requirements.
* Multiple tax jurisdictions
  - Support location-aware taxes, so states or countries can have their own tax rules if needed.
* CLI enhancements
  - Add command-line flags for input sources, output options, and interactive entry mode instead of only file-based input.
* Optional persistence/history
  - Add storage or export support for receipts and product metadata to enable reporting and reuse.