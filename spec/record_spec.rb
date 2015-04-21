require 'record'
require 'date'

describe Record do

  let(:record) { Record.new }

  describe "::initialize" do
    it "returns a Record object" do
      expect(record).to be_an_instance_of(Record)
    end

    context "with array populated from comma delimited input" do
      subject { record.comma_delimited }
      it { is_expected.to be_a(Array) }
      it { is_expected.not_to be_empty }
    end

    context "with array populated from pipe delimited input" do
      subject { record.pipe_delimited }
      it { is_expected.to be_a(Array) }
      it { is_expected.not_to be_empty }
    end

    context "with array populated from space delimited input" do
      subject { record.space_delimited }
      it { is_expected.to be_a(Array) }
      it { is_expected.not_to be_empty }
    end
  end

  describe "::normalizeData" do
    it "formats data to last first gender dob color" do
      record.normalizeData

      record.comma_delimited.each do |x|
        expect(x).to be_a(String)
        expect(x).to match(/\A([a-z]+)\s([a-z]+)\s([a-z]+)\s(\d{1,2})\/(\d{1,2})\/(\d{4})\s([a-z]+)\z/i)
      end

      record.pipe_delimited.each do |x|
        expect(x).to be_a(String)
        expect(x).to match(/\A([a-z]+)\s([a-z]+)\s([a-z]+)\s(\d{1,2})\/(\d{1,2})\/(\d{4})\s([a-z]+)\z/i)
      end

      record.space_delimited.each do |x|
        expect(x).to be_a(String)
        expect(x).to match(/\A([a-z]+)\s([a-z]+)\s([a-z]+)\s(\d{1,2})\/(\d{1,2})\/(\d{4})\s([a-z]+)\z/i)
      end
    end
  end

  describe "::mergeData" do
    it "combines all input data" do
      record.mergeData
      expect(record.merged).to be_a(Array)
      expect(record.merged).not_to be_empty
    end
  end

  describe "::splitArrayForSort" do
    it "splits merged data for sort" do
      record.mergeData.splitArrayForSort

      record.merged.each do |x|
        expect(x).to be_a(Array)
        expect(x).not_to be_empty
      end
    end
  end

  describe "::sortGenderAndLastName" do
    it "sorts merged array by gender and last name" do
      record.normalizeData.mergeData.splitArrayForSort.sortGenderAndLastName
      actual = Array.new

      record.merged.each do |x|
        actual.push(x[0])
      end

      expect(actual).to eq %w{ Hingis Kelly Kournikova Seles Abercrombie Bishop Bonk Bouillon Smith }
    end

    it "creates a result array" do
      record.normalizeData.mergeData.splitArrayForSort.sortGenderAndLastName
      expect(record.result).to be_a(Array)
      expect(record.result).not_to be_empty
    end
  end

  describe "::sortDob" do
    it "sorts merged array by dob" do
      record.normalizeData.mergeData.splitArrayForSort.sortDob
      actual = Array.new

      record.merged.each do |x|
        actual.push(x[0])
      end

      expect(actual).to eq %w{ Abercrombie Kelly Bishop Seles Bonk Bouillon Kournikova Hingis Smith }
    end

    it "creates a result array" do
      record.normalizeData.mergeData.splitArrayForSort.sortDob
      expect(record.result).to be_a(Array)
      expect(record.result).not_to be_empty
    end
  end

  describe "::sortLastName" do
    it "sorts merged array by last name" do
      record.normalizeData.mergeData.splitArrayForSort.sortLastName
      actual = Array.new

      record.merged.each do |x|
        actual.push(x[0])
      end

      expect(actual).to eq %w{ Smith Seles Kournikova Kelly Hingis Bouillon Bonk Bishop Abercrombie }
    end

    it "creates a result array" do
      record.normalizeData.mergeData.splitArrayForSort.sortLastName
      expect(record.result).to be_a(Array)
      expect(record.result).not_to be_empty
    end
  end
end
