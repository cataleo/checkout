# frozen_string_literal: true

require "spec_helper"
require_relative "./../lib/checkout"

def items_group
  [
    %w[GR1 SR1 GR1 GR1 CF1],
    %w[GR1 GR1],
    %w[SR1 SR1 GR1 SR1],
    %w[GR1 CF1 SR1 CF1 CF1]
  ]
end

def expected_total_price
  [22.45, 3.11, 16.61, 30.57]
end

RSpec.describe Checkout do
  subject(:checkout) { described_class }
  let(:pricing_rules) { PricingRules.new }
  let(:co) { checkout.new(pricing_rules) }

  it "has a version number" do
    expect(Checkout::VERSION).not_to be nil
  end

  describe "#total" do
    items_group.each_with_index do |cart, i|
      it "computes the correct cart total" do
        cart.each { |item| co.scan(item) }

        expect(co.total).to eq(expected_total_price[i])
      end
    end

    context "when an invalid product code is scanned" do
      items_group.each_with_index do |cart, i|
        it "avoids the incorrect item and computes the correct cart total" do
          (cart + ["randomCode1"]).each { |item| co.scan(item) }

          expect(co.total).to eq(expected_total_price[i])
        end
      end
    end

    context "when cart is empty" do
      it "corrrectly computes the correct cart total" do
        expect(co.total).to be_zero
      end
    end
  end

  describe "#scan" do
    context "when code is valid" do
      it "successfully adds the code to the cart" do
        co.scan("GR1")

        expect(co.cart).to include("GR1")
      end
    end

    context "when code is invalid" do
      it "does not add the code to the cart" do
        co.scan("RandomCode3")

        expect(co.cart).to be_empty
      end
    end

    context "when code is not a String" do
      it "does not add the code to the cart" do
        co.scan(3.13)

        expect(co.cart).to be_empty
      end
    end
  end

  describe "#initialize" do
    context "when class is instantiated correctly" do
      it "contains the correct class variables" do
        expect(co.pricing_rules).to be_a(PricingRules)
        expect(co.cart).to be_a(Array)
        expect(co.cart).to be_empty
      end
    end

    context "when the class is not instantied with a PricingRules instance" do
      it "raises an error" do
        expect do
          Checkout.new(Item)
        end.to raise_error(Checkout::NoPricingRulesError, "You need to input a new PricingRules instance")
      end
    end
  end
end
