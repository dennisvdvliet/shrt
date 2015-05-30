require 'rails_helper'

RSpec.describe Link, :type => :model do

  describe "#validate" do
    let(:link) { Link.new(url: "http://impraise.com")} # simple app so decided to no use any fixtures
    context "3 character short code supplied" do
      it "fails validation" do
        link.shortcode = "abc"
        expect(link.validate).to eq(false)
      end
    end
    context "short code with hyphen (-) is supplied" do
      it "fails validation" do
        link.shortcode = "123-abc"
        expect(link.validate).to eq(false)
      end
    end

    context "256 char long shortcode is supplied" do
      it "fails validation" do
        link.shortcode = "a" * 256
        expect(link.validate).to eq(false)
      end
    end
  end
  describe "#generate_code" do
    let(:link) { Link.new(url: "http://impraise.com")}

    context "no shortcode supplied" do
      it "generates a valid shortcode" do
        expect(link.shortcode).to eq(nil)
        link.validate
        expect(link.shortcode).to match(/[0-9a-zA-Z_]{4,255}/)
      end
    end

    context "valid short code supplied" do
      it "does not overwrite shortcode" do
        link.shortcode = "abcdef"
        link.validate
        expect(link.shortcode).to eq("abcdef")
      end
    end
  end


  describe "#track_redirect!" do
    let(:link) { Link.new(url: "http://impraise.com", shortcode: "abcdef")}

    context "a new redirect takes place" do
      it "increments redirect_count and updates updated_at" do
        old_redirect_count = link.redirect_count
        old_updated_at = link.updated_at
        link.track_redirect!
        expect(link.redirect_count).to eq(old_redirect_count + 1)
        expect(link.updated_at).not_to eq(old_updated_at)
      end
    end

  end
end
