defmodule Dozenex do  
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      import Kernel, except: [+: 2, -: 2, *: 2]
    end
  end

  def a + b when is_map(a) do
    Dozenex.Math.add(a,b)  
  end

  def a + b do
    Kernel.+(a,b)
  end

  def a - b when is_map(a) do
    Dozenex.Math.subtract(a,b)
  end

  def a - b do
    Kernel.-(a,b)
  end

  def a * b when is_map(a) do
    Dozenex.Math.multiply(a,b)
  end

  def a * b do
    Kernel.*(a,b)
  end

 

  defprotocol Decimal do
    def to_decimal(dozenal)
  end
  
  defprotocol Dozenal do
    def from_decimal(decimal)
  end


  defprotocol Math  do
    def add(a,b)
    def subtract(a,b)
    def multiply(a,b)
    def div(a,b)
    def rem(a,b)
  end

  def sigil_d(s, []), do: s |> String.split(".") |> _construct

  def _construct([w]), do: w |> Dozenex.Integer.construct
 
  def to_doz_words(doz = %Dozenex.Integer{}), do: doz |> Dozenex.Decimal.to_decimal |> to_doz_words
  def to_doz_words(0), do: ""
  def to_doz_words(1), do: "one"
  def to_doz_words(2), do: "two"
  def to_doz_words(3), do: "three"
  def to_doz_words(4), do: "four"
  def to_doz_words(5), do: "five"
  def to_doz_words(6), do: "six"
  def to_doz_words(7), do: "seven"
  def to_doz_words(8), do: "eight"
  def to_doz_words(9), do: "nine"
  def to_doz_words(10), do: "dec"
  def to_doz_words(11), do: "el"
  def to_doz_words(dec) when dec < 144, do: to_doz_words(div(dec,12)) <> " do " <> to_doz_words(rem(dec, 12))
  def to_doz_words(dec) when dec < 1728, do: to_doz_words(div(dec, 144)) <> " gro " <> to_doz_words(rem(dec, 144))
  def to_doz_words(dec) when dec < 20736, do: to_doz_words(div(dec, 1728)) <> " mo " <> to_doz_words(rem(dec, 1728))
  def to_doz_words(dec) when dec < 248832, do: to_doz_words(div(dec, 20736)) <> " do-mo " <> to_doz_words(rem(dec, 20736))
  def to_doz_words(dec) when dec < 2985984, 
    do: to_doz_words(div(dec, 248832)) <> " gro-mo " <> to_doz_words(rem(dec, 248832))
end
