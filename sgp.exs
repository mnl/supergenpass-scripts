#!/usr/bin/env elixir
# SuperGenPass in Elixir. Beta 0.2 spaghetti version
# Made by mnl@vandal.nu in 2018
domain = List.first(System.argv())
unless domain do # First argument is required
	System.stop(1)
	IO.puts("Usage ./sgp.exs domainname [length] [digest]")
end
len = cond do
  Enum.at(System.argv(),1) == nil ->
		15 # Default length
	true ->
    String.to_integer(Enum.at(System.argv(),1))
end

defmodule SuperGenPass do
	def dohash(hash) do
	  hash = Base.encode64(:crypto.hash(:md5, hash))
		hash = Regex.replace(~r/[(+\/=)]/, hash, fn ch -> 
			Map.get(%{"+" => "9", "/" => "8", "=" => "A"},ch) 
		end) # Replace illegal SGP chars. change to 3 String.replace?
		hash
	end
	def rehash(hash, n) do
	  hash = dohash(hash)
		if valid?(hash) && n < 1 do 
			hash
		else
			rehash(hash, n-1)
		end
	end
	def valid?(hash) do
		String.match?(hash, ~r/^[a-z](?=.*\d)(?=.*[A-Z])/)
	end
end

pass = String.trim(IO.gets("Password: "))
hash = SuperGenPass.rehash(pass <> ":" <> domain,9)

IO.puts(String.slice(hash,0..len-1))
