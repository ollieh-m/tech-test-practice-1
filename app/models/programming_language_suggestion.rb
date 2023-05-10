class ProgrammingLanguageSuggestion
  include ActiveModel::Model

  attr_accessor :username
  attr_reader :value # could be aliased as to_s

  def create
    # turning a newly initialized suggestion into a created suggestion
    # a created suggestion has been populated with an actual value
    # in a sense its state changes from incomplete to complete -
    # the indicator of that may be whether a value is present, but a failed creation might still count as complete

    @value = most_used_language
  end

  private

    def most_used_language
      used_languages.max_by do |language|
        used_languages.count(language)
      end
    end

    def used_languages
      github_repos.map do |repo|
        repo["language"]
      end
    end

    def github_repos
      @_github_repos ||= fetch_github_repos # doesn't need to be memoized really
    end

    def fetch_github_repos
      # move fetching repos to a GithubReposFetcher class
      # fetcher = GithubReposFetcher.new(username)
      # fetcher.fetch
      # fetcher.success?
      # fetcher.errors could be merged here
      # fetcher could return null object/empty array if there's a problem
      # e.g
      # fetcher.fetch
      # errors.merge(fetcher.errors) if fetcher.errors.any?
      # fetcher.result
      # or GithubClient::GetRepos.new(username).perform_request

      uri = URI("https://api.github.com/users/#{username}/repos")
      response = Net::HTTP.get_response(uri)
      parsed_response = JSON.parse(response.body)

      if response_valid?(parsed_response)
        parsed_response
      else
        []
      end
    end

    def response_valid?(parsed_response)
      if parsed_response.is_a?(Hash) && parsed_response["message"]
        errors.add(:base, message: parsed_response["message"])
        false
      else
        true
      end
    end
end
