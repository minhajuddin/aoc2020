defmodule Day8 do
  import Logger, only: [info: 1]

  defmodule State do
    defstruct visited: MapSet.new(), ptr: 0, acc: 0, instrs: nil
  end

  def solve(input_filepath) do
    part1(input_filepath)
  end

  defp part1(input_filepath) do
    instrs =
      input_filepath
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {k, v} -> {v, k} end)

    exec(%State{instrs: instrs})
  end

  defp exec(%State{} = state) do
    log(state, "EXECUTING")

    case {MapSet.member?(state.visited, state.ptr), state.instrs[state.ptr]} do
      {true, _} ->
        log(state, "INFINITE_LOOP")
        {:infinite_loop, state}
      {_, nil} ->
        {:end, state}

      {_, "nop " <> _arg_s} ->
        state
        |> visited(state.ptr)
        |> ptr(1)
        |> exec

      {_, "acc " <> arg_s} ->
        state
        |> visited(state.ptr)
        |> ptr(1)
        |> acc(arg_s)
        |> exec

      {_, "jmp " <> arg_s} ->
        state
        |> visited(state.ptr)
        |> ptr(arg_s)
        |> exec
    end
  end

  defp ptr(%State{} = state, ptr_delta_s) when is_binary(ptr_delta_s),
    do: ptr(state, String.to_integer(ptr_delta_s))

  defp ptr(%State{} = state, ptr_delta), do: %{state | ptr: state.ptr + ptr_delta}

  defp acc(%State{} = state, acc_delta_s),
    do: %{state | acc: state.acc + String.to_integer(acc_delta_s)}

  defp visited(%State{} = state, ptr), do: %{state | visited: MapSet.put(state.visited, ptr)}

  def log(%State{} = state, message) do
    info(%{
      message: message,
      ptr: state.ptr,
      acc: state.acc,
      current_instr: state.instrs[state.ptr],
      visited: state.visited
    })
  end
end
