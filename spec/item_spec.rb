# frozen_string_literal: true

require "spec_helper"
require_relative "./../lib/item"

RSpec.describe Item do
  subject(:item) { described_class }

  describe "PRODUCT_CODES" do
    it "contains only String items" do
      expect(item::PRODUCT_CODES).to be_all(String)
    end
  end

  describe "PRODUCT_INVENTORY" do
    context "when product is 'Green Tea'" do
      it "has the correct name and price" do
        expect(item::PRODUCT_INVENTORY["GR1"].name).to eq("Green Tea")
        expect(item::PRODUCT_INVENTORY["GR1"].price).to eq(3.11)
      end
    end

    context "when product is a 'Strawberries'" do
      it "has the correct name and price" do
        expect(item::PRODUCT_INVENTORY["SR1"].name).to eq("Strawberries")
        expect(item::PRODUCT_INVENTORY["SR1"].price).to eq(5.00)
      end
    end

    context "when product is a 'Coffee'" do
      it "has the correct name and price" do
        expect(item::PRODUCT_INVENTORY["CF1"].name).to eq("Coffee")
        expect(item::PRODUCT_INVENTORY["CF1"].price).to eq(11.23)
      end
    end

    it "contains only Struct values" do
      expect(item::PRODUCT_INVENTORY.values).to be_all(Struct)
    end
  end
end
