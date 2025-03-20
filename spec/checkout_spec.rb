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
end
