module QuestionsHelper
  def author_of(model)
    current_user == model.user if model.respond_to?(:user)
  end
end
