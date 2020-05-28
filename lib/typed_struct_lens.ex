defmodule TypedStructLens do
  @moduledoc """
  Documentation for TypedStructLens.
  """

  use TypedStruct.Plugin

  @impl true
  @spec field(atom(), any(), keyword()) :: Macro.t()
  def field(name, _type, opts) do
    quote do
      import Lens.Macros

      if unquote(opts[:lens] == :private) do
        deflensp unquote({name, [], []}), do: Lens.key(unquote(name))
      else
        deflens unquote({name, [], []}), do: Lens.key(unquote(name))
      end
    end
  end
end
