defmodule Common do
  def file_lines(file_path) do
    File.stream!(file_path) |> Enum.map(&String.trim/1)
  end

  def file_numbers(file_path) do
    file_lines(file_path) |> Enum.map(&String.to_integer/1)
  end

  def file_number_list(file_path) do
    File.read!(file_path)
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end

