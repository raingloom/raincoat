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
end)