defmodule Dozenex.Integer do
  defstruct digits: []
  alias Dozenex.{Decimal, Dozenal}
  alias Dozenex.Integer, as: I

  @doc """
    Constructs a Dozenex.Integer from a string representation of that integer.  This is primarily to be used
    by the ~d sigil defined in `Dozenex`
  """
  def construct(s) when is_binary(s), do: s |> to_char_list |> _convert_from_char_list |> _construct

  defimpl String.Chars, for: I do
    def to_string(%I{digits: digits}),
      do: digits |> I._convert_to_char_list |> Kernel.to_string
  end

  defimpl Inspect, for: I do
    def inspect(di, _opts), do: "~d(#{di})"
  end

  defimpl Decimal, for: I do
    @doc """
      Converts a `Dozenex.Integer` to a decimal `Integer`
    """
    def to_decimal(%I{ digits: digits}), do: digits |> Enum.reverse |> to_decimal
    def to_decimal([]), do: 0
    def to_decimal([h | t]), do: h + 12 * to_decimal(t)
  end

  defimpl Dozenex.Math, for: I do
    def add(a, b) do
      da = Decimal.to_decimal(a)
      db = Decimal.to_decimal(b)
      Dozenal.from_decimal(da + db)
    end

    def subtract(a, b) do
      da = Decimal.to_decimal(a)
      db = Decimal.to_decimal(b)
      Dozenal.from_decimal(da - db)
    end

    def multiply(a, b) do
      da = Decimal.to_decimal(a)
      db = Decimal.to_decimal(b)
      Dozenal.from_decimal(da * db)
    end

    def div(a, b) do
      da = Decimal.to_decimal(a)
      db = Decimal.to_decimal(b)
      Kernel.div(da, db) |> Dozenal.from_decimal
    end

    def rem(a, b) do
      da = Decimal.to_decimal(a)
      db = Decimal.to_decimal(b)
      Kernel.rem(da, db) |> Dozenal.from_decimal
    end
  end

  defimpl Dozenal, for: Integer do
     @doc """
      Converts a decimal `Integer` to a `Dozenex.Integer`
    """
    def from_decimal(dec) do
      digits = _from_decimal(dec)  |> Enum.reverse
      %I{digits: digits}
    end

    def _from_decimal(dec) when dec < 12, do: [dec]
    def _from_decimal(dec), do: [rem(dec, 12) | div(dec,12) |> _from_decimal]
  end

  def _construct(l) when is_list(l), do: %I{digits: l}

  def _convert_from_char_list([]), do: []
  def _convert_from_char_list([h | t]), do: [char_to_digit(h) | _convert_from_char_list(t)]

  def _convert_to_char_list([]), do: []
  def _convert_to_char_list([h | t]), do: [ digit_to_char(h) | _convert_to_char_list(t) ]

  @standard_digits ~c(0123456789)

  def char_to_digit(?X), do: 10
  def char_to_digit(?E), do: 11
  def char_to_digit(c) when c in @standard_digits, do: c - ?0

  def digit_to_char(10), do: ?X
  def digit_to_char(11), do: ?E
  def digit_to_char(d) when d in 0..9, do: d + ?0
end
