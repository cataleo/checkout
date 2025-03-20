# frozen_string_literal: true

require "spec_helper"
require_relative "./../lib/pricing_rules"

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

RSpec.describe PricingRules do
  subject(:pricing_rules) { described_class }
  let(:pr_instance) { pricing_rules.new }

  describe "#initialize" do
    it "correctly sets the total instance variable" do
      expect(pr_instance.total).to be_zero
      expect(pr_instance.total).to be_a(Integer)
    end
  end

  describe "#calculate_total" do
    context "when cart contains only valid items" do
      items_group.each_with_index do |cart, i|
        it "computes the correct cart total" do
          expect(pr_instance.calculate_total(cart)).to eq(expected_total_price[i])
          expect(pr_instance.calculate_total(cart)).to be_a(Float)
        end
      end
    end

    context "when cart contains also invalid items" do
      let(:cart) { %w[GR1 SR1 GR1 GR1 CF1 TRY$ hdg0] }

      it "computes the correct cart total" do
        expect(pr_instance.calculate_total(cart)).to eq(22.45)
      end
    end
  end
end
