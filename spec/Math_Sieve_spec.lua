require 'busted.runner'()


describe( "prime sieves", function()
	local sieve = require 'raincoat.Math.Sieve'
	describe( "test simple sieve", function()
		it( "tests accuracy", function()
			local primes, i = {}, 1
			for p in sieve.simple( 20 ) do
				primes[ i ], i = p, i + 1
			end
			assert.are.same( primes, { 2, 3, 5, 7, 11, 13, 17, 19 } )
		end)
	end)
	describe( "segmented sieve", function()
		it( "accuracy within segment size", function()
			local primes = {}
			local nextprime = sieve.segmented( 20 )
			for i = 1, 10 do
				primes[ i ] = nextprime()
			end
			assert.are.same( primes, { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 } )
		end)
		it( "accuracy outside segment size", function()
			local primes = {}
			local nextprime = sieve.segmented( 10 )
			for i = 1, 10 do
				primes[ i ] = nextprime()
			end
			assert.are.same( primes, { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 } )
		end)
	end)
end)