rtl:
	(cd .. && sbt "runMain hwitlbase.HWITLTopLevelVerilog" && cd synth)
../hw/gen/HWITLTopLevel.v: rtl
	
synth: ../hw/gen/HWITLTopLevel.v
	yosys -s top.ys -L synthesis.log
pnr: HWITLTopLevel.json
	nextpnr-ice40 --package ct256 --hx8k -l pnr.log --json HWITLTopLevel.json --pcf pins.pcf --asc hwitl.asc --freq 12
	icepack -v hwitl.asc hwitl.bit
prog: hwitl.bit
	iceprog hwitl.bit
clean:
	rm *.v
	rm *.blif
	rm *.json
	rm *.cfg
	rm *.asc