defmodule ExCloudflareTest do
  use ExUnit.Case
  doctest ExCloudflare

  test "greets the world" do
    assert ExCloudflare.hello() == :world
  end
end
