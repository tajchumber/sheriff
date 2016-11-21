defmodule Diplomat.Plug.LoadResource do
  @moduledoc """
  Load the request's target resource and store it on the connection for use downstream.
  """

  import Diplomat.Plug

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, opts) do
    opts
    |> resource_loader
    |> fetch_resource(conn)
  end

  defp resource_loader(opts) do
    {from_opts(opts, :resource_loader), opts}
  end

  defp fetch_resource({loader, opts}, conn) do
    case apply(loader, :fetch_resource, [conn_tuple(conn), conn.params]) do
      {:ok, resource} ->
        Plug.Conn.put_private(conn, :diplomat_resource, resource)
      {:error, _reason} ->
        handle_error(:resource_missing, conn, opts)
    end
  end
end
