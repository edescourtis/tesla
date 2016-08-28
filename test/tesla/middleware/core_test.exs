defmodule CoreTest do
  use ExUnit.Case

  describe "Tesla.Middleware.BaseUrl" do
    alias Tesla.Middleware.BaseUrl
    use Tesla.Middleware.TestCase, middleware: BaseUrl

    test "base without slash, path without slash" do
      env = BaseUrl.call(%Tesla.Env{url: "path"}, [], "http://example.com")
      assert env.url == "http://example.com/path"
    end

    test "base without slash, path with slash" do
      env = BaseUrl.call(%Tesla.Env{url: "/path"}, [], "http://example.com")
      assert env.url == "http://example.com/path"
    end

    test "base with slash, path without slash" do
      env = BaseUrl.call(%Tesla.Env{url: "path"}, [], "http://example.com/")
      assert env.url == "http://example.com/path"
    end

    test "base with slash, path with slash" do
      env = BaseUrl.call(%Tesla.Env{url: "/path"}, [], "http://example.com/")
      assert env.url == "http://example.com/path"
    end

    test "skip double append" do
      env = BaseUrl.call(%Tesla.Env{url: "http://other.foo"}, [], "http://example.com")
      assert env.url == "http://other.foo"
    end
  end



  describe "Tesla.Middleware.Query" do
    alias Tesla.Middleware.Query
    use Tesla.Middleware.TestCase, middleware: Query

    test "joining default query params" do
      env = Query.call %Tesla.Env{}, [], page: 1
      assert env.query == [page: 1]
    end

    test "should not override existing key" do
      env = Query.call %Tesla.Env{query: [page: 1]}, [], [page: 5]
      assert env.query == [page: 1, page: 5]
    end
  end



  describe "Tesla.Middleware.Headers" do
    alias Tesla.Middleware.Headers
    use Tesla.Middleware.TestCase, middleware: Headers

    test "merge headers" do
      env = Headers.call %Tesla.Env{headers: %{"Authorization" => "secret"}}, [], %{"Content-Type" => "text/plain"}
      assert env.headers == %{"Authorization" => "secret", "Content-Type" => "text/plain"}
    end
  end



  # test "Tesla.Middleware.BaseUrlFromConfig" do
  #   Application.put_env(:tesla, SomeModule, [base_url: "http://example.com"])
  #   env = call(Tesla.Middleware.BaseUrlFromConfig, %{url: "/path"}, otp_app: :tesla, module: SomeModule)
  #   assert env.url == "http://example.com/path"
  # end
end
