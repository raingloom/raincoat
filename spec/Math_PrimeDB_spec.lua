require 'busted.runner'()


describe( "Prime database", function()
	local db = require 'raincoat.Math.PrimeDB'
	it( "preserves module table", function()
		assert.are.equals( db, db.configure( 1024 ) )
	end)
	it( "gives correct initial prime", function()
		assert.are.equals(db[1], 2)
	end)
	it( "gives correct 10001st prime", function()
		assert.are.equals( db[10001], 104743 )
	end)
end)