require "rails_helper"

RSpec.shared_examples "when empty" do |field|
  it do
    sub.save
    expect(sub.errors[field].first).to eql I18n.t("errors.messages.blank")
  end
end

RSpec.describe Subject, type: :model do
  let(:sub) {FactoryBot.create :subject}
  subject {sub}

  it "should be valid" do
    expect(sub).to be_valid
  end

  describe "#name" do
    it {is_expected.to validate_presence_of :name}
    it {is_expected.to validate_length_of(:name)
      .is_at_most(Settings.name_length_maximum)}

    context "when the name is empty" do
      before {sub.name = nil}
      it_behaves_like "when empty", :name
    end

    context "when the name is too long" do
      before {sub.name = Faker::name * 1000}
      it do
        sub.save
        expect(sub.errors[:name].first)
          .to eql I18n.t("errors.messages.too_long",
          count: Settings.name_length_maximum)
      end
    end
  end

  describe "#description" do
    it {is_expected.to validate_presence_of :description}
    it {is_expected.to validate_length_of(:description)
      .is_at_most(Settings.content_text_max_length)}

    context "when the description is empty" do
      before {sub.description = nil}
      it_behaves_like "when empty", :description
    end
  end

  describe ".associations" do
    it "should have many course_subjects" do
      is_expected.to have_many(:course_subjects).dependent :destroy
    end

    it "should have many subject_users" do
      is_expected.to have_many(:subject_users).dependent :destroy
    end
  end

end

