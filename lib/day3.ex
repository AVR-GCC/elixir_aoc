defmodule Day3 do
  def mulshit(input) do
    pattern = :binary.compile_pattern(["mul(", ")"])
    splitted = String.split(input, pattern)
    Enum.reduce(splitted, 0, fn snip, acc -> 
      splitted_snip = String.split(snip, ",")
      case splitted_snip do
        [first, second] -> 
          case {Integer.parse(first), Integer.parse(second)} do
            {{x, ""}, {y, ""}} -> acc + x * y
            _ -> acc
          end
        _ -> acc
      end
    end)
  end

  def part1(path) do
    input = File.read!(path)
    mulshit(input)
  end

  def part2(path) do
    input = File.read!(path)
    splitted = String.split(input, ~r/don't\(\).*?do\(\)/s)
    Enum.reduce(splitted, 0, fn snip, acc -> acc + mulshit(snip) end)
  end
end
