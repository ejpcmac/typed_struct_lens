defmodule TypedStructLens do
  @external_resource "README.md"
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- @moduledoc -->")
             |> Enum.fetch!(1)

  use TypedStruct.Plugin

  @impl true
  @spec field(atom(), any(), keyword(), Macro.Env.t()) :: Macro.t()
  def field(name, _type, opts, _env) do
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
