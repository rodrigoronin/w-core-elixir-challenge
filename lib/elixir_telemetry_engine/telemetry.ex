defmodule ElixirTelemetryEngine.Telemetry do
  @moduledoc """
  The Telemetry context.
  """

  import Ecto.Query, warn: false
  alias ElixirTelemetryEngine.Repo

  alias ElixirTelemetryEngine.Telemetry.Node
  alias ElixirTelemetryEngine.Telemetry.NodeMetric

  def get_node_metric_by_node_id(node_id) do
    from(nm in NodeMetric, where: nm.node_id == ^node_id)
    |> Repo.one()
  end

  @doc """
  Returns the list of nodes.

  ## Examples

      iex> list_nodes()
      [%Node{}, ...]

  """
  def list_nodes do
    Repo.all(Node)
  end

  @doc """
  Gets a single node.

  Raises `Ecto.NoResultsError` if the Node does not exist.

  ## Examples

      iex> get_node!(123)
      %Node{}

      iex> get_node!(456)
      ** (Ecto.NoResultsError)

  """
  def get_node!(id), do: Repo.get!(Node, id)

  @doc """
  Creates a node.

  ## Examples

      iex> create_node(%{field: value})
      {:ok, %Node{}}

      iex> create_node(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_node(attrs) do
    %Node{}
    |> Node.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a node.

  ## Examples

      iex> update_node(node, %{field: new_value})
      {:ok, %Node{}}

      iex> update_node(node, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a node.

  ## Examples

      iex> delete_node(node)
      {:ok, %Node{}}

      iex> delete_node(node)
      {:error, %Ecto.Changeset{}}

  """
  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node changes.

  ## Examples

      iex> change_node(node)
      %Ecto.Changeset{data: %Node{}}

  """
  def change_node(%Node{} = node, attrs \\ %{}) do
    Node.changeset(node, attrs)
  end

  alias ElixirTelemetryEngine.Telemetry.NodeMetric

  @doc """
  Returns the list of node_metrics.

  ## Examples

      iex> list_node_metrics()
      [%NodeMetric{}, ...]

  """
  def list_node_metrics do
    Repo.all(NodeMetric)
  end

  @doc """
  Gets a single node_metric.

  Raises `Ecto.NoResultsError` if the Node metric does not exist.

  ## Examples

      iex> get_node_metric!(123)
      %NodeMetric{}

      iex> get_node_metric!(456)
      ** (Ecto.NoResultsError)

  """
  def get_node_metric!(id), do: Repo.get!(NodeMetric, id)

  @doc """
  Creates a node_metric.

  ## Examples

      iex> create_node_metric(%{field: value})
      {:ok, %NodeMetric{}}

      iex> create_node_metric(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_node_metric(attrs) do
    %NodeMetric{}
    |> NodeMetric.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a node_metric.

  ## Examples

      iex> update_node_metric(node_metric, %{field: new_value})
      {:ok, %NodeMetric{}}

      iex> update_node_metric(node_metric, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_node_metric(%NodeMetric{} = node_metric, attrs) do
    node_metric
    |> NodeMetric.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a node_metric.

  ## Examples

      iex> delete_node_metric(node_metric)
      {:ok, %NodeMetric{}}

      iex> delete_node_metric(node_metric)
      {:error, %Ecto.Changeset{}}

  """
  def delete_node_metric(%NodeMetric{} = node_metric) do
    Repo.delete(node_metric)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node_metric changes.

  ## Examples

      iex> change_node_metric(node_metric)
      %Ecto.Changeset{data: %NodeMetric{}}

  """
  def change_node_metric(%NodeMetric{} = node_metric, attrs \\ %{}) do
    NodeMetric.changeset(node_metric, attrs)
  end

  def upsert_node_metric(node_id, data) do
    import Ecto.Query

    existing = from(node in NodeMetric, where: node.node_id == ^node_id) |> Repo.one()

    attrs = %{
      node_id: node_id,
      status: data.status,
      total_events_processed: data.event_count,
      last_payload: data.last_payload,
      last_seen_at: data.last_seen_at
    }

    case existing do
      nil -> %NodeMetric{} |> NodeMetric.changeset(attrs) |> Repo.insert()

      record -> record |> NodeMetric.changeset(attrs) |> Repo.update()
    end
  end
end
