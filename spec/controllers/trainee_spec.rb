require "rails_helper"

RSpec.describe Supervisors::TraineesController, type: :controller do
  context ".Trainees" do
    before(:each) { @course_user = FactoryBot.create :course_user }
    let(:user) {FactoryBot.create :user }

    describe "#new" do
      it "return view new" do
        get :new, params: { id: @course_user.course.id }
        expect(assigns(:users)).to include user
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end
    end

    describe "#create" do
      let(:subject) {assigns(:subject)}
      let(:course_user) {assigns(:course_user)}
      context "when valid" do
        before(:each) do
          post :create, params: {
            course_user: {id: @course_user.id, user_ids: [user.id]}
          }
        end

        it "save success" do
          expect(flash[:success]).to eq(I18n.t("messages.save_success"))
          expect(response).to have_http_status(204)
        end
      end

      context "when invalid" do
        before(:each) do
          post :create, params: {
            course_user: {id: @course_user.id, user_ids: []}
          }
        end

        it "save unsuccess" do
          expect(flash[:danger]).to eq(I18n.t("messages.save_unsuccess"))
          expect(course_user).to eq(nil)
          expect(response).to have_http_status(204)
        end
      end
    end

    describe "#destroy" do
      context "when valid" do
      before(:each) do
        course_user = FactoryBot.create :course_user
        delete :destroy, params: {id: course_user.user_id, course_id: course_user.course_id}, format: :json
      end
        it "respond_to json message" do
          @expect = {status: "success", message: I18n.t("messages.destroy_success")}.to_json
          expect(response.body).to eq(@expect)
          expect(response).to have_http_status(200)
        end
      end
      context "when invalid" do
        it "not_found user" do
          course_user = FactoryBot.create :course_user
          delete :destroy, params: {id: 999, course_id: course_user.course_id}, format: :json
          @expect = {status: "ok", message: I18n.t("messages.not_found")}.to_json
          expect(response.body).to eq(@expect)
        end
        it "not_found course" do
          course_user = FactoryBot.create :course_user
          delete :destroy, params: {id: course_user.user_id, course_id: nil}, format: :json
          @expect = {status: "ok", message: I18n.t("messages.not_found")}.to_json
          expect(response.body).to eq(@expect)
        end
      end
    end
  end
end
