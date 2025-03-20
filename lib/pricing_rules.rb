# frozen_string_literal: true

# Class used to compute the total price of the cart
class PricingRules
  attr_reader :total

  # Method to initialize a new PricingRules instance with a total of zero
  def initialize
    @total = 0
  end

  # Method that computes the total price of the cart
  # Returns a Float / Integer
  def calculate_total(cart)
    total = 0

    cart.tally.each do |product_code, quantity|
      case product_code
      when "GR1"
        total += total_green_tea_items(quantity) * original_green_tea_price
      when "SR1"
        total += quantity * strawberry_price(quantity)
      when "CF1"
        total += quantity * coffee_price(quantity)
      end
    end

    @total = total
  end

  private

  # Define methods to extract the original items prices
  %i[green_tea strawberry coffee].each_with_index do |name, i|
    method_name = "original_#{name}_price"
    price = Item::PRODUCT_INVENTORY.values[i][:price]
    define_method(method_name) do
      instance_variable_set("@#{method_name}", price)
    end
  end

  # Method used to set the green tea quantity, guided by the discount rule: 1+1 (buy-one-get-one-free)
  # Returns an Integer
  def total_green_tea_items(quantity)
    (quantity / 2.0).ceil
  end

  # Method used to set the strawberry price, guided by the discount rule:
  # if buy 3 or more, price drops to 4.5
  # Returns a Float
  def strawberry_price(quantity)
    quantity >= 3 ? 4.5 : original_strawberry_price
  end

  # Method used to set the coffee price, guided by the discount rule:
  # if buy 3 or more, price drops to 2/3 of the original price
  # Returns a Float
  def coffee_price(quantity)
    quantity >= 3 ? (original_coffee_price * 2 / 3) : original_coffee_price
  end
end
