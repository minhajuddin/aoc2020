defmodule Mix.Tasks.Solve do
  @moduledoc "Solves for today's challenge"
  @shortdoc "Solves for today's challenge"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    day_i = day_i()
    Mix.shell().info("Solving Day#{day_i}")
    input_filepath = Path.relative_to_cwd("../inputs/day#{day_i}")

    Module.concat(Elixir, "Day#{day_i}")
    |> apply(:solve, [input_filepath])
  end

  @est_utc_offset -1 * 5 * 60 * 60
  defp day_i, do: (DateTime.utc_now() |> DateTime.add(@est_utc_offset, :second)).day
end
