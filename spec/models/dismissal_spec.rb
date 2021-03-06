# Copyright (c) Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

require "spec_helper"

describe Dismissal do
  let(:dismissal) { Dismissal.new }
  subject { dismissal }
  describe "Validations" do
    describe "enrollment" do
      context "should be valid when" do
        it "enrollment is not null" do
          dismissal.enrollment = Enrollment.new
          expect(dismissal).to have(0).errors_on :enrollment
        end

        it "enrollment has an ended scholarship" do
          dismissal.enrollment = FactoryBot.create(:enrollment, :admission_date => 2.months.ago.to_date)
          scholarship = FactoryBot.create(:scholarship, :start_date => 3.months.ago.to_date, :end_date => 3.months.from_now.to_date)
          scholarship_duration = FactoryBot.create(:scholarship_duration, :start_date => 1.month.ago.to_date, :end_date => 2.months.from_now.to_date, :cancel_date => nil, :scholarship => scholarship, :enrollment => dismissal.enrollment)
          dismissal.date = 5.months.from_now.to_date
          expect(dismissal).to have(0).errors_on :enrollment
        end
      end
      context "should have error blank when" do
        it "enrollment is null" do
          dismissal.enrollment = nil
          expect(dismissal).to have_error(:blank).on :enrollment
        end
      end

      context "should have error has_scholarship when" do
        it "enrollment has a valid scholarship during date" do
          dismissal.enrollment = FactoryBot.create(:enrollment, :admission_date => 2.months.ago.to_date)
          scholarship = FactoryBot.create(:scholarship, :start_date => 3.months.ago.to_date, :end_date => 3.months.from_now.to_date)
          scholarship_duration = FactoryBot.create(:scholarship_duration, :start_date => 1.month.ago.to_date, :end_date => 2.months.from_now.to_date, :cancel_date => nil, :scholarship => scholarship, :enrollment => dismissal.enrollment)
          dismissal.date = 1.month.from_now.to_date
          expect(dismissal).not_to be_valid
          expect(dismissal.errors[:enrollment]).to include I18n.translate("activerecord.errors.models.dismissal.enrollment_has_scholarship")
        end
      end
    end
    describe "dismissal_reason" do
      context "should be valid when" do
        it "dismissal_reason is not null" do
          dismissal.dismissal_reason = DismissalReason.new
          expect(dismissal).to have(0).errors_on :dismissal_reason
        end
      end
      context "should have error blank when" do
        it "dismissal_reason is null" do
          dismissal.dismissal_reason = nil
          expect(dismissal).to have_error(:blank).on :dismissal_reason
        end
      end
    end
    describe "date" do
      context "should be valid when" do
        it "date is not null" do
          dismissal.enrollment = FactoryBot.create(:enrollment, :admission_date => 3.days.ago.to_date)
          dismissal.date = Date.today
          expect(dismissal).to have(0).errors_on :date
        end
        it "is after enrollment admission date" do
          enrollment = FactoryBot.create(:enrollment, :admission_date => 3.days.ago.to_date)
          dismissal.enrollment = enrollment
          dismissal.date = Date.today
          expect(dismissal).to have(0).errors_on :date
        end
      end
      context "should have error when" do
        it "date is null" do
          dismissal.date = nil
          expect(dismissal).to have_error(:blank).on :date
        end
        it "is before enrollment admission date" do
          enrollment = FactoryBot.create(:enrollment, :admission_date => 3.days.ago.to_date)
          dismissal.enrollment = enrollment
          dismissal.date = 4.days.ago.to_date
          expect(dismissal).to have_error(:date_before_enrollment_admission_date).on :date
        end
      end
    end
  end
  describe "Methods" do
    describe "to_label" do
      it "should return the expected string" do
        dismissal_date = "#{Date.today}"
        dismissal.date = dismissal_date
        expect(dismissal.to_label).to eql(dismissal_date)
      end
    end
  end
end
