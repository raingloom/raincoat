local primes = require 'raincoat.Math.PrimeDB'
--let's not add the configure hack to every single library, kay?
assert( primes.configured, "The prime database needs to be pre-configured" )


local Factorize = {}


function Factorize.primeFactors( n )
	local ret, i = {}, 1
	local limit = math.floor( math.sqrt( n ) )
	local prime, j = primes[ 1 ], 2
	while prime <= limit do
		if n%prime==0 then
			ret[ i ], i = prime, i + 1
		end
		prime, j = primes[ j ], j + 1
	end
	return ret
end


function Factorize.factorize( n, primeFactors )
	local ret = {}
	primeFactors = primeFactors or Factorize.primeFactors( n )
	for i = 1, #primeFactors do
		local prime, k = primeFactors[ i ], 0
		while n % prime == 0 do
			k = k + 1
			n = n / prime
		end
		ret[ prime ] = k
	end
	return ret
end


return Factorize