class ProgrammingLanguageSuggestionsController < ApplicationController
  def new
    @suggestion = ProgrammingLanguageSuggestion.new
  end

  def create
    @suggestion = ProgrammingLanguageSuggestion.new(programming_language_suggestion_params)
    @suggestion.create

    render :new
  end

  private

    def programming_language_suggestion_params
      params.require(:programming_language_suggestion).permit(:username)
    end
end
