defmodule Luhn do

    @moduledoc """
    Implemantation of Luhn algorithm. Calculates and verifies a number.
    """

    @doc """
    Verify a number using the luhn algorithm.
    Returns {:ok, number} or {:error, number}

    ## Examples

      iex> Luhn.verify(79927398713)
      {:ok, 79927398713}

      iex> Luhn.verify(79927398711)
      {:error, 79927398711}
    """
    def verify(number) when is_integer(number) do
        digits = Integer.digits(number)
        {original_number, check_digit} =
          digits
          |> Enum.split(Enum.count(digits) - 1)
          |> Tuple.to_list()
          |> Enum.map(&(Enum.reduce(&1, fn (d, acc) -> acc * 10 + d end)))
          |> List.to_tuple()

        calculated = calculate(original_number)

        case calculated do
          {:ok, ^number, ^original_number, ^check_digit}
            -> {:ok, number}
          _ -> {:error, number}
        end
    end

    @doc """
    Calculate a numbers check digit using the luhn algorithm.
    Returns {:ok, number, original_number, check_digit} or {:error, number}

    ## Examples

      iex> Luhn.calculate(7992739871)
      {:ok, 79927398713, 7992739871, 3}
    """
    def calculate(number) when is_integer(number) do
        digits = Integer.digits(number)

        odd_sum =
          digits
          |> Enum.take_every(2)
          |> Enum.reduce(fn(d, acc) -> d + acc end)

        even_sum =
          digits
          |> Enum.drop(1)
          |> Enum.take_every(2)
          |> Enum.map(&(&1 * 2))
          |> Enum.map(fn(d) -> if(d > 9, do: d - 9, else: d) end)
          |> Enum.reduce(fn(d, acc) -> d + acc end)

        sum = odd_sum + even_sum

        check_digit =
          sum * 9
          |> Integer.digits()
          |> List.last

        {:ok, number * 10 + check_digit, number, check_digit}
    end
end
