require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question_with_answers, user: @user) }
  let(:answer) { question.answers.first }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer to database' do
        expect { post 'create', question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'current user link to the new answer' do
        post 'create', question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns("answer").user).to eq @user
      end

      it 're-render template create' do
        post 'create', question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        question
        expect { post 'create', question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post 'create', question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template 'answers/create'
        expect(assigns(:answer).errors).to match_array(["Body can't be blank"])
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    describe 'by Author' do
      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          attributes = answer.attributes.symbolize_keys.slice(*attributes_for(:answer).keys)
          patch :update, id: answer, answer: attributes, format: :js
          expect(assigns(:answer)).to eq answer
          expect(assigns(:answer).body).to eq answer.body
        end

        it 'change answer attributes' do
          patch :update, id: answer, answer: { body: 'new body 43433'}, format: :js
          answer.reload
          expect(answer.body).to eq 'new body 43433'
        end

        it 'render updated answer' do
          patch :update, id: answer, answer: attributes_for(:answer), format: :js
          expect(response).to render_template 'update'
        end
      end

      context 'with invalid attributes' do
        let!(:body) { answer.body }

        before { patch :update, id: answer, answer: { body: nil}, format: :js }

        it 'does not change answer attributes' do
          answer.reload
          expect(answer.body).to eq body
          expect(flash[:error]).to eq ["Body can't be blank"]
        end

        it 're-renders edit view' do
          expect(response).to render_template 'update'
        end
      end
    end

    describe 'by Non-author' do
      let(:new_answer) {create(:answer, question: answer.question, user: create(:user))}
      #let(:attributes) { new_answer.attributes.symbolize_keys.slice(*attributes_for(:answer).keys) }

      context 'with valid attributes' do

        it 'assigns the requested answer to @answer' do
          patch :update, id: new_answer, answer: { body: new_answer.body}, format: :js
          expect(assigns(:answer)).to eq new_answer
          expect(assigns(:answer).body).to eq new_answer.body
        end

        it 'not change answer attributes' do
          body = new_answer.body
          patch :update, id: new_answer, answer: { body: 'new body 43433'}, format: :js
          new_answer.reload
          expect(new_answer.body).to eq body
          expect(flash[:error]).to eq ["Only the author can edit answer"]
        end

        it 'render updated answer' do
          patch :update, id: new_answer, answer: { body: new_answer.body}, format: :js
          expect(response).to render_template 'update'
        end
      end

      context 'with invalid attributes' do
        before { patch :update, id: new_answer, answer: { body: nil}, format: :js }

        it 'does not change answer attributes' do
          body = new_answer.body
          new_answer.reload
          expect(new_answer.body).to eq body
          expect(flash[:error]).to eq ["Only the author can edit answer"]
        end

        it 're-renders update view' do
          expect(response).to render_template 'update'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { answer }

    it 'author deletes answer' do
      expect {delete :destroy, id: answer, question_id: question, format: :js}.to change(Answer, :count).by(-1)
      expect(flash[:success]).to eq ["Ответ успешно удален."]
    end

    it 'non-author deletes answer' do
      new_answer = create(:answer, user: create(:user), question: question)
      expect {delete :destroy, id: new_answer, question_id: question, format: :js}.to_not change(Answer, :count)
      expect(flash[:error]).to eq ['Запрешено удалять чужие ответы.']
    end

    it 'redirects to index view' do
      delete :destroy, id: answer, question_id: question, format: :js
      expect(response).to render_template 'destroy'
    end
  end

  describe 'PATCH #accept' do
    sign_in_user

    describe 'by Author question' do
      let!(:answer1) { create(:answer, question: question, user: @user) }
      let!(:answer2) { create(:answer, question: question, user: @user) }

      it 'assigns the requested params' do
        patch :accept, id: answer1, format: :js
        expect(assigns(:answer)).to eq answer1
        expect(flash[:error]).to eq nil
      end

      it 'accept answer' do
        expect(answer1.accept).to eq false
        expect(answer2.accept).to eq false
        patch :accept, id: answer1, format: :js
        expect(flash[:error]).to eq nil
        answer1.reload
        answer2.reload
        expect(answer1.accept).to eq true
        expect(answer2.accept).to eq false
      end

      it 'change accept answer' do
        expect(answer1.accept).to eq false
        expect(answer2.accept).to eq false
        patch :accept, id: answer1, format: :js
        patch :accept, id: answer2, format: :js
        answer1.reload
        answer2.reload
        expect(answer1.accept).to eq false
        expect(answer2.accept).to eq true
      end

      it 'render accept view' do
        patch :accept, id: answer1, format: :js
        expect(response).to render_template 'accept'
      end

    end

    describe 'by Non-author question' do
      let(:question) { create(:question, user: create(:user)) }
      let(:answer1) { create(:answer, question: question, user: create(:user), accept: true) }
      let(:answer2) { create(:answer, question: question, user: create(:user)) }

      it 'not change accept answer' do
        expect(answer1.accept).to eq true
        expect(answer2.accept).to eq false
        patch :accept, id: answer2, format: :js
        answer1.reload
        answer2.reload
        expect(answer1.accept).to eq true
        expect(answer2.accept).to eq false
      end

      it 'render accept view' do
        patch :accept, id: answer1, format: :js
        expect(response).to render_template 'accept'
      end
    end
  end
end
