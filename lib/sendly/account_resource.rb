# frozen_string_literal: true

module Sendly
  # Account resource for accessing account information, credits, and API keys
  class AccountResource
    # @param client [Sendly::Client] The API client
    def initialize(client)
      @client = client
    end

    # Get account information
    #
    # @return [Sendly::Account]
    def get
      response = @client.get("/account")
      Account.new(response)
    end

    # Get credit balance
    #
    # @return [Sendly::Credits]
    #
    # @example
    #   credits = client.account.credits
    #   puts "Available: #{credits.available_balance} credits"
    def credits
      response = @client.get("/credits")
      Credits.new(response)
    end

    # Get credit transaction history
    #
    # @param limit [Integer, nil] Maximum number of transactions to return
    # @param offset [Integer, nil] Number of transactions to skip
    # @return [Array<Sendly::CreditTransaction>]
    def transactions(limit: nil, offset: nil)
      params = {}
      params[:limit] = limit if limit
      params[:offset] = offset if offset

      response = @client.get("/credits/transactions", params)
      response.map { |data| CreditTransaction.new(data) }
    end

    # List API keys for the account
    #
    # @return [Array<Sendly::ApiKey>]
    def api_keys
      response = @client.get("/keys")
      response.map { |data| ApiKey.new(data) }
    end

    # Get a specific API key by ID
    #
    # @param key_id [String] API key ID
    # @return [Sendly::ApiKey]
    def api_key(key_id)
      response = @client.get("/keys/#{key_id}")
      ApiKey.new(response)
    end

    # Get usage statistics for an API key
    #
    # @param key_id [String] API key ID
    # @return [Hash] Usage statistics
    def api_key_usage(key_id)
      @client.get("/keys/#{key_id}/usage")
    end
  end
end
