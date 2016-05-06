require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_with_answers, user: user) }
  #let!(:answer) { create(:answer, user: user, question: question) }
  let(:answer) { question.answers.first }

  describe 'GET #index' do
    #let(:answers) { create_list(:answer, 2) }
    let(:answers) { question.answers }

    before { get :index, question_id: question }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

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
        expect { post 'create', question_id: question, answer: attributes_for(:answer).merge(user_id: user) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post 'create', question_id: question, answer: attributes_for(:answer).merge(user_id: user)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post 'create', question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(question.answers, :count)
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

    it 'deletes answer' do
      expect {delete :destroy, id: answer, question_id: question}.to change(Answer, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: answer, question_id: question
      expect(response).to redirect_to question_path(question)
    end
  end

end
