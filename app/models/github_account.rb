# frozen_string_literal: true

module CheckHigh
  # Maps Github account details to attributes
  class GithubAccount
    def initialize(gh_account)
      @gh_account = gh_account
    end

    def username
      @gh_account['login'] + '@github'
    end

    def email
      @gh_account['email'] || @gh_account['login'] + '@email'
    end
  end
end
