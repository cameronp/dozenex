defmodule Dozenex.Integer do
  defstruct digits: []

  @doc """
    Constructs a Dozenex.Integer from a string representation of that integer.  This is primarily to be used
    by the ~d sigil defined in `Dozenex`
  """
  def construct(s) when is_binary(s), do: s |> to_char_list |> _convert_from_char_list |> _construct 

  defimpl String.Chars, for: Dozenex.Integer do
    def to_string(%Dozenex.Integer{digits: digits}),
      do: digits |> Dozenex.Integer._convert_to_char_list |> Kernel.to_string
  end
  
  defimpl Inspect, for: Dozenex.Integer do
    def inspect(di, _opts), do: "~d(#{di})"
  end

  defimpl Dozenex.Decimal, for: Dozenex.Integer do
    @doc """
      Converts a `Dozenex.Integer` to a decimal `Integer`
    """
    def to_decimal(%Dozenex.Integer{ digits: digits}), do: digits |> Enum.reverse |> to_decimal
    def to_decimal([]), do: 0
    def to_decimal([h | t]), do: h + 12 * to_decimal(t)
  end

  defimpl Dozenex.Math, for: Dozenex.Integer do
    def add(a, b) do
      da = Dozenex.Decimal.to_decimal(a)
      db = Dozenex.Decimal.to_decimal(b)
      Dozenex.Dozenal.from_decimal(da + db)
    end
    
    def subtract(a, b) do
      da = Dozenex.Decimal.to_decimal(a)
      db = Dozenex.Decimal.to_decimal(b)
      Dozenex.Dozenal.from_decimal(da - db)
    end

    def multiply(a, b) do
      da = Dozenex.Decimal.to_decimal(a)
      db = Dozenex.Decimal.to_decimal(b)
      Dozenex.Dozenal.from_decimal(da * db)
    end

    def div(a, b) do
      da = Dozenex.Decimal.to_decimal(a)
      db = Dozenex.Decimal.to_decimal(b)
      Kernel.div(da, db) |> Dozenex.Dozenal.from_decimal
    end

    def rem(a, b) do
      da = Dozenex.Decimal.to_decimal(a)
      db = Dozenex.Decimal.to_decimal(b)
      Kernel.rem(da, db) |> Dozenex.Dozenal.from_decimal
    end
  end

  defimpl Dozenex.Dozenal, for: Integer do
     @doc """
      Converts a decimal `Integer` to a `Dozenex.Integer`
    """
    def from_decimal(dec) do 
      digits = _from_decimal(dec)  |> Enum.reverse
      %Dozenex.Integer{digits: digits}
    end

    def _from_decimal(dec) when dec < 12, do: [dec]
    def _from_decimal(dec), do: [rem(dec, 12) | div(dec,12) |> _from_decimal]
  end

  def _construct(l) when is_list(l), do: %Dozenex.Integer{digits: l}

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
