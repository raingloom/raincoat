require 'busted.runner'()


describe( "Permutation generators", function()
	local Permute = require 'raincoat.Permute'
	describe( "unordered version", function()
		it( "returns all permutations exactly once", function()
			local permutations = {}
			for permutation in Permute.unordered{ 1, 2 } do
				
				--simple hashing to make lookups possible
				table.sort( permutation )
				local stringHash = table.concat( permutation )
				
				--only counted once
				assert.is.falsy( permutations[ stringHash ] )
				
				permutations[ stringHash ] = true
			end
			
			--returned all
			assert.are.same(
				{
					[''] = true,--empty
					['1'] = true,
					['2'] = true,
					['12'] = true,
				}, permutations
			)
		end)
	end)
	
	describe( "limited integer sequence generator", function()
		it( "returns all permutations exactly once", function()
			local permutations = {}
			for permutation in Permute.withinLimits{ 1, 1 } do
				local stringHash = table.concat( permutation )
				assert.is.falsy( permutations[ stringHash ] )
				permutations[ stringHash ] = true
			end
			assert.are.same(
				{
					['00'] = true,
					['01'] = true,
					['10'] = true,
					['11'] = true,
				}, permutations
			)
		end)
		it( "works with custom lower limit", function()
			local permutations = {}
			for permutation in Permute.withinLimits( { 2, 2 }, 1 ) do
				local stringHash = table.concat( permutation )
				assert.is.falsy( permutations[ stringHash ] )
				permutations[ stringHash ] = true
			end
			assert.are.same(
				{
					['11'] = true,
					['12'] = true,
					['21'] = true,
					['22'] = true,
				}, permutations
			)
		end)
	end)
end)