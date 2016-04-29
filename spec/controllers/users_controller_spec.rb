require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:users) { create_list(:user, 2) }

    before { get :index }

    it 'populates an array of all users' do
      expect(assigns(:users)).to match_array(users)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: user }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get 'new' }

    it 'assigns a new User to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get 'edit', id: user}

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new user to database' do
        expect { post 'create', user: attributes_for(:user) }.to change(User, :count).by(1)
      end

      it 'redirects to show view' do
        post 'create', user: attributes_for(:user)
        expect(response).to redirect_to user_path(assigns(:user))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the user' do
        expect { post 'create', user: attributes_for(:invalid_user) }.to_not change(User, :count)
      end

      it 're-renders new view' do
        post 'create', user: attributes_for(:invalid_user)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested user to @user' do
        patch :update, id: user, user: attributes_for(:user)
        expect(assigns(:user)).to eq user
      end

      it 'change user attributes' do
        patch :update, id: user, user: { name: 'new name 2322'}
        user.reload
        expect(user.name).to eq 'new name 2322'
      end

      it 'redirects to the updated user' do
        patch :update, id: user, user: attributes_for(:user)
        expect(response).to redirect_to user
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: user, user: { name: nil}}

      it 'does not change user attributes' do
        user.reload
        expect(user.name).to eq 'MyString'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { user }
    it 'deletes user' do
      expect {delete :destroy, id: user}.to change(User, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: user
      expect(response).to redirect_to users_path
    end
  end

end
