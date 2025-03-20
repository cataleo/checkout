# frozen_string_literal: true

class Item
  PRODUCT = Struct.new(:product_code, :name, :price)

  PRODUCT_CODES = %w[GR1 SR1 CF1].freeze

  PRODUCT_INVENTORY = {
    "GR1" => PRODUCT.new("GR1", "Green Tea", 3.11),
    "SR1" => PRODUCT.new("SR1", "Strawberries", 5.00),
    "CF1" => PRODUCT.new("CF1", "Coffee", 11.23)
  }.freeze
end
