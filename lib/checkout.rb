# frozen_string_literal: true

require_relative "checkout/version"

# Class used to scan items and ccalculate the total price of the cart
class Checkout
  class NoPricingRulesError < StandardError; end
  attr_reader :cart, :pricing_rules

  PRODUCT_CODES = %w[GR1 SR1 CF1].freeze

  # Method to initialize a new Checkout instance with an empty cart and a PricingRules instance
  def initialize(pricing_rules)
    raise NoPricingRulesError, "You need to input a new PricingRules instance" unless pricing_rules.is_a?(PricingRules)

    @pricing_rules = pricing_rules
    @cart = []
  end

  # Method used to scan a product code and add it to the cart
  def scan(product_code)
    return unless valid_string?(product_code)

    cart << product_code if PRODUCT_CODES.include?(product_code.upcase)
  end

  # Method that calculates the toal price of the cart
  # Returns a Float / Integer
  def total
    pricing_rules.calculate_total(cart)
  end

  private

  # Private method that checks if product_code is a String instance
  def valid_string?(product_code)
    product_code.is_a?(String)
  end
end
