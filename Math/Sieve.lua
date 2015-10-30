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
	return coroutine.wrap(
		function()
			local sieve = {}
			local primes = { 2 }
			local primeCount = 1
			local lastPrime = 2
			local offset = 0
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
end


return sieve
