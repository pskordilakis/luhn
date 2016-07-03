defmodule Luhn.CLI do

  @moduledoc """
  Handle the command line parsing
  """

  def main(argv) do
    argv
    |> parse()
    |> process()
  end



  defp parse(argv) do
    arguments
      = OptionParser.parse(argv,
          switches: [
            help: :boolean,
            verify: :boolean,
            calculate: :boolean,
            number: :integer
          ],
          aliases: [
            h: :help,
            v: :verify,
            c: :calculate,
            n: :number
          ])

    case arguments do
      { [ help: true], _, _}
        -> :help
      { [verify: true, number: number], _, _}
        -> {:verify, number}
      { [calculate: true, number: number], _, _}
        -> {:calculate, number}
      _ -> :help
    end
  end

  defp process({:verify, number}) do
      case Luhn.verify(number) do
        {:ok, number} -> IO.puts("#{number} passed check")
        _ -> IO.puts("#{number} failed to  pass check")
      end
  end

  defp process({:calculate, number}) do
      case Luhn.calculate(number) do
        {:ok, number_with_check_digit, ^number, _}
          -> IO.puts("#{number} -> #{number_with_check_digit}")
        _ -> IO.puts("could not calculate check digit for #{number}")
      end
  end

  defp process(:help) do
      IO.puts """
      usage: luhn {-verify | -check} -n number
      """
  end
end
