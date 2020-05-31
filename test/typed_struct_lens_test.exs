defmodule TypedStructLensTest do
  use ExUnit.Case

  ############################################################################
  ##                               Test data                                ##
  ############################################################################

  defmodule TestStruct do
    use TypedStruct

    typedstruct do
      plugin TypedStructLens

      field :a_field, String.t()
      field :another_field, integer()
      field :private_lens, term(), lens: :private
    end

    def call_private_lens, do: private_lens()
  end

  defmodule PrivateByDefault do
    use TypedStruct

    typedstruct do
      plugin TypedStructLens, lens: :private

      field :a_field, String.t()
      field :another_field, integer()
      field :public_lens, term(), lens: :public
    end

    def call_a_field, do: a_field()
    def call_another_field, do: another_field()
  end

  defmodule WithPrefix do
    use TypedStruct

    typedstruct do
      plugin TypedStructLens, prefix: :lens_

      field :a_field, String.t()
    end
  end

  defmodule WithPostfix do
    use TypedStruct

    typedstruct do
      plugin TypedStructLens, postfix: :_lens

      field :a_field, String.t()
    end
  end

  ############################################################################
  ##                             Standard cases                             ##
  ############################################################################

  test "generates a lens for each field" do
    assert TestStruct.a_field() == Lens.key(:a_field)
    assert TestStruct.another_field() == Lens.key(:another_field)
  end

  test "generates a private lens if the :lens option is set to :private" do
    assert TestStruct.call_private_lens() == Lens.key(:private_lens)

    assert_raise UndefinedFunctionError, ~r"private_lens/0 is undefined", fn ->
      TestStruct.private_lens()
    end
  end

  test "generates a private lense for all fields by default if :lens is globally
        set to :private" do
    assert PrivateByDefault.call_a_field() == Lens.key(:a_field)
    assert PrivateByDefault.call_another_field() == Lens.key(:another_field)

    assert_raise UndefinedFunctionError, ~r"a_field/0 is undefined", fn ->
      PrivateByDefault.a_field()
    end

    assert_raise UndefinedFunctionError, ~r"another_field/0 is undefined", fn ->
      PrivateByDefault.another_field()
    end
  end

  test "can still generate a public lens when lens: :private is the default" do
    assert PrivateByDefault.public_lens() == Lens.key(:public_lens)
  end

  test "the name of generated functions can be prefixed" do
    assert WithPrefix.lens_a_field() == Lens.key(:a_field)
  end

  test "the name of generated functions can be postfixed" do
    assert WithPostfix.a_field_lens() == Lens.key(:a_field)
  end
end
