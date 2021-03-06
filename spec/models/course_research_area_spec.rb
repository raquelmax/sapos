# Copyright (c) Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

require "spec_helper"

describe CourseResearchArea do
  let(:course_research_area) { CourseResearchArea.new }
  subject { course_research_area }
  describe "Validations" do
    describe "course" do
      context "should be valid when" do
        it "course is not null" do
          course_research_area.course = Course.new
          expect(course_research_area).to have(0).errors_on :course
        end
      end
      context "should have error blank when" do
        it "course is null" do
          course_research_area.course = nil
          expect(course_research_area).to have_error(:blank).on :course
        end
      end
    end
    describe "research_area" do
      context "should be valid when" do
        it "research_area is not null" do
          course_research_area.research_area = ResearchArea.new
          expect(course_research_area).to have(0).errors_on :research_area
        end
      end
      context "should have error blank when" do
        it "research_area is null" do
          course_research_area.research_area = nil
          expect(course_research_area).to have_error(:blank).on :research_area
        end
      end
    end

    describe "course_id" do
      context "should be valid when" do
        it "don't exists the course for the same research_area" do
          course_research_area.course = Course.new
          expect(course_research_area).to have(0).errors_on :course_id
        end
      end
      context "should have uniqueness error when" do
        it "already exists the same course for the same research_area" do
          course_research_area.course = FactoryBot.create(:course)
          course_research_area.research_area = FactoryBot.create(:research_area)
          FactoryBot.create(:course_research_area, :course => course_research_area.course, :research_area => course_research_area.research_area)
          expect(course_research_area).to have_error(:unique_pair).on :course_id
        end
      end
    end
  end
end


