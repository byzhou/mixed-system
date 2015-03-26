#build dir org
basedir		:= .
srcdir		:= src
tcldir		:= config
includedir  := $(srcdir)

#tcl files
makegen_tcl := generated_vars.tcl
readin_tcl  := t_.tcl
wave_tcl	:= readWaveforms.tcl
tcl_files	:= $(tcldir)/$(readin_tcl) $(tcldir)/$(wave_tcl) 

#src files
#all the erb module files
modulefiles := $(shell ls -d $(srcdir)/* | grep "\.erb\.v" | grep -v "t_" )
#all the erb moduel testbenches
testBench   := $(shell ls -d $(srcdir)/* | grep "\.erb\.v" | grep "t_" )
#testbench after erb
vTestBench	:= $(shell ls -d $(srcdir)/* | grep "t_" | grep -v "\.erb" )
erbfiles	:= $(srcdir)/t_LFSR.erb.v
srcfiles	:= $(erbfiles:%.erb.v=%.v) 

#simulate rules
#################################################################
toplevel 	:= t_LFSR
runtime		:= 100ns
#################################################################

# define build directory
build_dir	:= build
# specify the variables in tcl file
vsim_vars	:= \
	set INCLUDE_DIR $(includedir); \
	set TOP	$(toplevel).v; \
	set TOPLEVEL $(toplevel); \
	set RUNTIME $(runtime); \
	set MAKEGEN $(makegen_tcl); \

.PHONY: prep vsim view clean all default

#search all the .erb.v files and erb them
#vpath %.erb.v $(srcdir)

#erb rules
$(srcdir)\/%.v:%.erb.v
	erb $< > $@

all:vsim

#verilog rules
$(srcfiles):$(testBench)
$(testBench):$(modulefiles)

#generate the build directory
$(build_dir): $(srcfiles)
	mkdir $(build_dir);\
	echo -e "*\n!.gitignore" > $(build_dir)/.gitignore

#copy all the src files do the build directory and all the tcl files
prep: | $(build_dir) 
	cp $(tcl_files) $(build_dir)/;\
	cp $(vTestBench) $(build_dir)/;\
	echo '$(vsim_vars)' > $(build_dir)/$(makegen_tcl);\
	echo -e "*\n!.gitignore" > $(build_dir)/.gitignore

#simulation
vsim:prep
	cd $(build_dir); \
	vsim -c -do $(readin_tcl) ; \
	cd .. ; 

#view waveforms
view:vsim
	cd $(build_dir); \
	vcd2wlf $(toplevel).vcd $(toplevel).wlf ; \
	vsim -view $(toplevel).wlf -do readWaveforms.tcl; \
	cd .. ; 

clean:
	rm -rf $(build_dir)/*
	echo -e "*\n!.gitignore" > $(build_dir)/.gitignore
