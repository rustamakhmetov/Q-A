require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: @user || create(:user)) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get 'new' }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get 'edit', id: question}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question to database' do
        expect { post 'create', question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'current user link to the new question' do
        post 'create', question: attributes_for(:question)
        expect(assigns("question").user).to eq @user
      end

      it 'redirects to show view' do
        post 'create', question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post 'create', question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post 'create', question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context "by Author" do
      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(assigns(:question)).to eq question
        end

        it 'change question attributes' do
          patch :update, id: question, question: { title: 'new title 2322', body: 'new body 43433'}, format: :js
          question.reload
          expect(question.title).to eq 'new title 2322'
          expect(question.body).to eq 'new body 43433'
          expect(flash[:success]).to eq "Вопрос успешно обновлен."
        end

        it 'render template "update" for the updated question' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(response).to render_template 'update'
        end
      end

      context 'with invalid attributes' do
        let!(:title) { question.title }

        before { patch :update, id: question, question: { title: 'new title', body: nil}, format: :js }

        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq title
          expect(question.body).to eq 'MyText'
          expect(flash[:error0]).to eq "Body can't be blank"
        end

        it 're-renders edit view' do
          expect(response).to render_template 'update'
        end
      end
    end

    context "by Non-author" do
      let(:new_question) { create(:question, user: create(:user)) }
      let(:title) { new_question.title }
      let(:body) { new_question.body }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, id: new_question, question: attributes_for(:question), format: :js
          expect(assigns(:question)).to eq new_question
        end

        it 'not change question attributes' do
          patch :update, id: new_question, question: { title: 'new title 2322', body: 'new body 43433'}, format: :js
          question.reload
          expect(new_question.title).to eq title
          expect(new_question.body).to eq body
          expect(flash[:error]).to eq "Only the author can edit question"
        end

        it 'render template "update"' do
          patch :update, id: new_question, question: attributes_for(:question), format: :js
          expect(response).to render_template 'update'
        end
      end

      context 'with invalid attributes' do

        before { patch :update, id: new_question, question: { title: 'new title', body: nil}, format: :js }

        it 'does not change question attributes' do
          new_question.reload
          expect(new_question.title).to eq title
          expect(new_question.body).to eq body
        end

        it 're-renders edit view' do
          expect(response).to render_template 'update'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { question }

    it 'author deletes question' do
      expect {delete :destroy, id: question}.to change(Question, :count).by(-1)
    end

    it 'non-author deletes question' do
      new_question = create(:question, user: create(:user))
      expect {delete :destroy, id: new_question}.to_not change(Question, :count)
    end

    it 'redirects to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
end
