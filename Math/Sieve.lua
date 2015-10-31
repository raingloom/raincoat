local sieve = {}
--TODO:multi-threaded sieve


---Simple Sieve of Erasthotenes
--@param sieveSize search for primes less or equal to this number
--a larger sieve consumes more memory
--@return an iterator over primes not exceeding sieveSize
function sieve.simple ( sieveSize )
	return coroutine.wrap(
		function()
			local sieve = {}
			local lastPrime = 2
			for i = 1, sieveSize do
				sieve[ i ] = true
			end
			coroutine.yield( 2 )
			local foundNew = true
			while foundNew do
				foundNew = false
				for i = lastPrime, sieveSize, lastPrime do
					sieve[ i ] = false
				end
				for i = lastPrime, sieveSize do
					if sieve[ i ] then
						foundNew = true
						lastPrime = i
						coroutine.yield( i )
						break
					end
				end
			end
		end
	)
end


---Iterates over all primes using a segmented Sieve of Erasthotenes
--@param sieveSize search for primes less or equal to this number
--a larger sieve consumes more memory
--@return an iterator over all primes
--the iterator runs indefinitely, so it is up to you to break execution after the necessary number of primes was found
function sieve.segmented( sieveSize )
	local primes = {}
	local generator = coroutine.wrap(
		function()
			local sieve = {}
			primes[1] = 2
			local primeCount = 1
			local lastPrime = 2
			local offset = 0
			coroutine.yield( 2 )
			while true do
				for i = 1, sieveSize do
					sieve[ i ] = true
				end
				for i = 1, primeCount do
					local prime = primes[ i ]
					for j = prime - offset, sieveSize, prime do
						sieve[ j ] = false
					end
				end
				local foundNew = true
				while foundNew do
					foundNew = false
					for i = lastPrime - offset, sieveSize, lastPrime do
						sieve[ i ] = false
					end
					for i = lastPrime - offset, sieveSize do
						if sieve[ i ] then
							foundNew = true
							lastPrime = i + offset
							primeCount = primeCount + 1
							primes[ primeCount ] = lastPrime
							coroutine.yield( lastPrime )
							break
						end
					end
				end
				offset = offset + sieveSize
			end
		end
	)
	return function( command, ... )
		if command then
			if command == 'getPrimes' then
				return primes
			elseif command == 'setPrimes' then
				primes = ...
			else
				error "invalid command"
			end
		else
			return generator()
		end
	end
end


--[[--
	WARNING: this function does NO sanity checks on the commands you pass to it.
	@type function
	@name segmentedPrimeGenerator
	@param [command] the command to execute
	@param [...] paramters sent to the command
	This is the function returned by Sieve.segmented.
	It does some special things, which one should only mess around with if one _really_ needs them.
	The function takes an optional `command` argument, which can tell it to do some hackeries.
	Current hackeries:
		`getPrimes`
			returns the internally used sequence of primes
			it is not a copy of the table, it is the same table, a referenced data structure, modifying it can cause unwanted things to happen
			bad things even
		`setPrimes`
			set the prime sequence to this table
			be cautious with this one
]]


return sieve