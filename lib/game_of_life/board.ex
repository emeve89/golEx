defmodule GameOfLife.Board do
  def add_cells(alive_cells, new_cells) do
    alive_cells ++ new_cells
    |> Enum.uniq
  end

  def remove_cells(alive_cells, kill_cells) do
    alive_cells -- kill_cells
  end

  def keep_alive_tick(alive_cells) do
    alive_cells
    |> Enum.map(&(Task.Supervisor.async(
                  {GameOfLife.TasksSupervisor, GameOfLife.NodeManager.random_node},
                  GameOfLife.Board, :keep_alive_or_nilify, [alive_cells, &1])))
    |> Enum.map(&Task.await(&1))
    |> remove_nil_cells
  end

  def become_alive_tick(alive_cells) do
    GameOfLife.Cell.dead_neighbours(alive_cells)
    |> Enum.map(&(Task.Supervisor.async(
                  {GameOfLife.TasksSupervisor, GameOfLife.NodeManager.random_node},
                  GameOfLife.Board, :become_alive_or_nulify, [alive_cells, &1])))
    |> Enum.map(&Task.await(&1))
    |> remove_nil_cells
  end

  def keep_alive_or_nilify(alive_cells, cell) do
    if GameOfLife.Cell.keep_alive?(alive_cells, cell), do: cell, else: nil
  end

  def become_alive_or_nulify(alive_cells, cell) do
    if GameOfLife.Cell.become_alive?(alive_cells, cell), do: cell, else: nil
  end

  defp remove_nil_cells(cells) do
    cells
    |> Enum.filter(fn cell -> cell != nil end)
  end
end