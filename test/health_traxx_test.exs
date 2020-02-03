defmodule HealthTraxxTest do
  use ExUnit.Case
  doctest HealthTraxx

  test "greets the world" do
    assert HealthTraxx.hello() == :world
  end
end
