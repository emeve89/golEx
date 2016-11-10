defmodule GameOfLife.NodeManager do
  def all_nodes do
    [node | Node.list]
  end

  def random_node do
    all_nodes |> Enum.random
  end
end