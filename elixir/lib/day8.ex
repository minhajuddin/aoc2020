defmodule Day8 do
  import Logger, only: [info: 1]

  defmodule State do
    defstruct visited: MapSet.new(), ptr: 0, acc: 0, instrs: nil, instr_count: nil
  end

  def solve(input_filepath) do
    part1(input_filepath)
    part2(input_filepath)
  end

  defp part2(input_filepath) do
    input_filepath
    |> parse
    |> maybe_toggle_instr_and_exec(0)
  end

  defp maybe_toggle_instr_and_exec(%State{} = state, line_number) do
    # NOTE: we execute even when there is no change :(
    state
    |> toggle_instr(line_number)
    |> exec
    |> case do
      {:end, state} ->
        log(state, "ENDED_NORMALLY")

      {:infinite_loop, _state} ->
        log(state, "INF")
        maybe_toggle_instr_and_exec(state, line_number + 1)
    end
  end

  defp toggle_instr(state, line_number) do
    new_instr = toggle(state.instrs[line_number])

    instrs = Map.put(state.instrs, line_number, new_instr)
    %{state | instrs: instrs}
  end

  defp toggle("acc" <> _ = instr), do: instr
  defp toggle("jmp" <> rest), do: "nop" <> rest
  defp toggle("nop" <> rest), do: "jmp" <> rest

  defp part1(input_filepath) do
    input_filepath
    |> parse
    |> exec
    |> case do
      {:end, state} ->
        log(state, "ENDED_NORMALLY")

      {:infinite_loop, state} ->
        log(state, "INFINITE_LOOP")
    end
  end

  defp parse(input_filepath) do
    instrs =
      input_filepath
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {k, v} -> {v, k} end)

    %State{instrs: instrs, instr_count: map_size(instrs)}
  end

  defp exec(%State{} = state) do
    # log(state, "EXECUTING")

    case {MapSet.member?(state.visited, state.ptr), state.instrs[state.ptr]} do
      {true, _} ->
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
