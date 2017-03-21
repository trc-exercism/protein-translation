defmodule ProteinTranslation do
  @spec of_rna(String.t()) :: { atom,  list(String.t()) }
  def of_rna(rna) do
    _of_rna(Enum.map(Enum.chunk(to_charlist(rna), 3), fn (c) -> of_codon(to_string(c)) end), [])
  end

  defp _of_rna([{:error, _}|_], _), do: {:error, "invalid RNA"}
  defp _of_rna([{:ok, "STOP"}|_], acc), do: {:ok, Enum.uniq(acc)}
  defp _of_rna([], acc), do: {:ok, Enum.uniq(acc)}
  defp _of_rna([{:ok, codon}|t], acc), do: _of_rna(t, acc ++ [codon])

  @spec of_codon(String.t()) :: { atom, String.t() }
  def of_codon(codon) do
    cond do
      codon == "UGU" or codon == "UGC" -> { :ok, "Cysteine" }
      codon == "UUA" or codon == "UUG" -> { :ok, "Leucine" }
      codon == "AUG" -> { :ok, "Methionine" }
      codon == "UUU" or codon == "UUC" -> { :ok, "Phenylalanine" }
      codon == "UCU" or codon == "UCC" or codon == "UCA" or codon == "UCG" -> { :ok, "Serine" }
      codon == "UGG" -> { :ok, "Tryptophan" }
      codon == "UAU" or codon == "UAC" -> { :ok, "Tyrosine" }
      codon == "UAA" or codon == "UAG" or codon == "UGA" -> { :ok, "STOP" }
      true -> { :error, "invalid codon" }
    end
  end
end
