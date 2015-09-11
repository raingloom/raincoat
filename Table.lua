function table.copy ( t, tgt, iter )
	tgt = tgt or {}
	for k, v in (iter or pairs)( t ) do
		tgt [ k ] = v
	end
	return tgt
end
