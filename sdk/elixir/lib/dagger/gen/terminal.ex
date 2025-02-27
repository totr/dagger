# This file generated by `dagger_codegen`. Please DO NOT EDIT.
defmodule Dagger.Terminal do
  @moduledoc "An interactive terminal that clients can connect to."

  alias Dagger.Core.Client
  alias Dagger.Core.QueryBuilder, as: QB

  @derive Dagger.ID
  @derive Dagger.Sync
  defstruct [:query_builder, :client]

  @type t() :: %__MODULE__{}

  @doc "A unique identifier for this Terminal."
  @spec id(t()) :: {:ok, Dagger.TerminalID.t()} | {:error, term()}
  def id(%__MODULE__{} = terminal) do
    query_builder =
      terminal.query_builder |> QB.select("id")

    Client.execute(terminal.client, query_builder)
  end

  @doc """
  Forces evaluation of the pipeline in the engine.

  It doesn't run the default command if no exec has been set.
  """
  @spec sync(t()) :: {:ok, Dagger.Terminal.t()} | {:error, term()}
  def sync(%__MODULE__{} = terminal) do
    query_builder =
      terminal.query_builder |> QB.select("sync")

    with {:ok, id} <- Client.execute(terminal.client, query_builder) do
      {:ok,
       %Dagger.Terminal{
         query_builder:
           QB.query()
           |> QB.select("loadTerminalFromID")
           |> QB.put_arg("id", id),
         client: terminal.client
       }}
    end
  end
end

defimpl Jason.Encoder, for: Dagger.Terminal do
  def encode(terminal, opts) do
    {:ok, id} = Dagger.Terminal.id(terminal)
    Jason.Encode.string(id, opts)
  end
end

defimpl Nestru.Decoder, for: Dagger.Terminal do
  def decode_fields_hint(_struct, _context, id) do
    {:ok, Dagger.Client.load_terminal_from_id(Dagger.Global.dag(), id)}
  end
end
