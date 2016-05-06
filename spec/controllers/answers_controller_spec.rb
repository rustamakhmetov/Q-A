require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question_with_answers, user: @user) }
  let(:answer) { question.answers.first }

  describe 'GET #new' do
    sign_in_user

    before { get 'new', question_id: question }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get 'edit', id: answer}

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer to database' do
        expect { post 'create', question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'current user link to the new answer' do
        post 'create', question_id: question, answer: attributes_for(:answer)
        expect(assigns("answer").user).to eq @user
      end

      it 'redirects to show view' do
        post 'create', question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        question
        expect { post 'create', question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post 'create', question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, id: answer, answer: { body: 'new body 43433'}
        answer.reload
        expect(answer.body).to eq 'new body 43433'
      end

      it 'redirects to the updated answer' do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      let!(:body) { answer.body }

      before { patch :update, id: answer, answer: { body: nil} }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq body
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { answer }

    it 'author deletes answer' do
      expect {delete :destroy, id: answer, question_id: question}.to change(Answer, :count).by(-1)
    end

    it 'non-author deletes answer' do
      new_answer = create(:answer, user: create(:user), question: question)
      expect {delete :destroy, id: new_answer, question_id: question}.to_not change(Answer, :count)
    end

    it 'redirects to index view' do
      delete :destroy, id: answer, question_id: question
      expect(response).to redirect_to question_path(question)
    end
  end

end
