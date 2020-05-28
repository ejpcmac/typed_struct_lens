defmodule TypedStructLens do
  @moduledoc """
  Documentation for TypedStructLens.
  """

  use TypedStruct.Plugin

  @impl true
  @spec field(atom(), any(), keyword()) :: Macro.t()
  def field(name, _type, opts) do
    prefix = opts[:prefix]
    postfix = opts[:postfix]
    function_name = :"#{prefix}#{name}#{postfix}"

    quote do
      import Lens.Macros

      if unquote(opts[:lens] == :private) do
        deflensp unquote({function_name, [], []}), do: Lens.key(unquote(name))
      else
        deflens unquote({function_name, [], []}), do: Lens.key(unquote(name))
      end
    end
  end
end
