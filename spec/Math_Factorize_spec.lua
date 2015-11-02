require 'busted.runner'()

describe( "Factorization module", function()
	require 'raincoat.Math.PrimeDB'.configure(1024)
	local Factorize = require 'raincoat.Math.Factorize'
	it( "gives correct prime factors", function()
		local factors = Factorize.primeFactors( 2*5*13 )
		table.sort( factors )--the order they are returned in should not matter
		assert.are.same( { 2, 5, 13 }, factors )
	end)
	it( "gives correct prime factors with multiplicities", function()
		local factors = Factorize.factorize( 2^1*5^3*7^2 )
		assert.are.same( { [2] = 1, [5] = 3, [7] = 2 }, factors )
	end)
end)
