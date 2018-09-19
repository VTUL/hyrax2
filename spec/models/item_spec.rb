# Generated via
#  `rails generate hyrax:work Item`
require 'rails_helper'

RSpec.describe Item do

  describe "#validates_with" do
    before { subject.title = nil }
    it "ensures the item has a title" do
      expect(subject).not_to be_valid
      expect(subject.errors.messages[:title]).to eq(["Your item must have a title."])
    end

    before { subject.rights = nil }
    it "ensures the item has a right" do
      expect(subject).not_to be_valid
      expect(subject.rights).to include("must be obtained from University Libraries Special Collections, Virginia Tech.")
    end

    before { subject.identifier = nil }
    it "ensures the item has an identifier" do
      expect(subject).not_to be_valid
      expect(subject.errors.messages[:identifier]).to eq(["Your item must have an identifier."])
    end

    before { subject.rights_holder = nil }
    it "ensures the item has a rights holder" do
      expect(subject).not_to be_valid
      expect(subject.rights_holder).to eq("Special Collections, University Libraries, Virginia Tech")
    end
  end

  describe ".properties" do
    subject { described_class.properties.keys }
    it { is_expected.to include("medium", "format", "location", "resource_type", "creator", "contributor", "description", "keyword", "rights", "publisher", "date_created", "date", "subject", "language", "identifier", "related_url", "bibliographic_citation", "coverage", "source", "rights_holder") }
  end

  # test multi-valued and single-valued newly defined fields
  describe "primary metadata" do
    it "has dc location property" do
      subject.location = ['foo', 'bar']
      expect(subject.location).to eq ['foo', 'bar']
    end
    it "has dc rights property" do
      subject.rights = 'foo'
      expect(subject.rights).to eq 'foo'
    end
    it "has dc date property" do
      subject.date = 'foo'
      expect(subject.date).to eq 'foo'
    end
    it "has dc bibliographic_citation property" do
      subject.bibliographic_citation = 'foo'
      expect(subject.bibliographic_citation).to eq 'foo'
    end
    it "has dc medium property" do
      subject.medium = ['foo', 'bar']
      expect(subject.medium).to eq ['foo', 'bar']
    end
    it "has dc rights holder property" do
      subject.rights_holder = 'foo'
      expect(subject.rights_holder).to eq 'foo'
    end
    it "has dc format property" do
      subject.format = ['foo', 'bar']
      expect(subject.format).to eq ['foo', 'bar']
    end
  end

  describe "metadata" do
    it "has descriptive metadata" do
      expect(subject).to respond_to(:title)
      expect(subject).to respond_to(:description)
      expect(subject).to respond_to(:creator)
      expect(subject).to respond_to(:source)
      expect(subject).to respond_to(:date_created)
      expect(subject).to respond_to(:date)
      expect(subject).to respond_to(:rights)
      expect(subject).to respond_to(:language)
      expect(subject).to respond_to(:resource_type)
      expect(subject).to respond_to(:identifier)
      expect(subject).to respond_to(:subject)
      expect(subject).to respond_to(:related_url)
      expect(subject).to respond_to(:contributor)
      expect(subject).to respond_to(:coverage)
      expect(subject).to respond_to(:location)
      expect(subject).to respond_to(:medium)
      expect(subject).to respond_to(:bibliographic_citation)
      expect(subject).to respond_to(:rights_holder)
      expect(subject).to respond_to(:keyword)
      expect(subject).to respond_to(:format)
    end
  end
end
