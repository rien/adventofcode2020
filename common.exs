defmodule Common do
  def fileNumbers(filePath) do
    {:ok, contents} = File.read filePath
    String.split(contents, "\n")
      |> Enum.filter(fn s -> s != "" end)
      |> Enum.map(&String.to_integer(&1))
  end
end

