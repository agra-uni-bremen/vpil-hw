target ?= HWITLTopLevel
rngSeed ?= 0

synth_hx8k:
	echo "Synthesis"
	/usr/bin/time -o time_synth.log -f "%E real\n%U user\n%S system" yosys -d -s $(target).ys -l $(target).log
	grep -A22 "Printing statistics*" $(target).log > synth_stat.log
pnr_hx8k: synth_hx8k
	echo "Place and Route"
	/usr/bin/time -o time_pnr.log -f "%E real\n%U user\n%S system" nextpnr-ice40 -l $(target)_pnr.log --hx8k --package ct256 --json $(target).json --asc $(target).asc --pcf-allow-unconstrained --seed $(rngSeed)
	grep -A7 "Info: Device utilisation*" $(target)_pnr.log > pnr_stat.log
	grep "Max frequency for clock *" $(target)_pnr.log | tail -1 >> pnr_stat.log
pack_hx8k: pnr_hx8k
	echo "Bitstream packing"
	icepack -v $(target).asc $(target).bit
all_hx8k: synth_hx8k pnr_hx8k pack_hx8k
	grep -A22 "Printing statistics*" $(target).log
	grep -A7 "Info: Device utilisation*" $(target)_pnr.log
	grep "Max frequency for clock *" $(target)_pnr.log | tail -1
clean:
	rm -f *.blif
	rm -f *.json
	rm -f *.asc
	rm -f *.bit
	rm -f *.log
	rm -f *_netlist.v
