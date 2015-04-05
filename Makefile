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

#testbench after erb
vTestBench	:= $(shell ls -d $(srcdir)/* | grep "t_" | grep "erbv")
targetVFiles:= $(vTestBench : t_%.erbv = $(srcdir)/t_%.v)

#simulate rules
#################################################################
toplevel 	:= t_conf
runtime		:= 20000ns
#################################################################

# define build directory
build_dir	:= build
# specify the variables in tcl file
vsim_vars	:= \
	set INCLUDE_DIR $(includedir); \
	set TOP	$(toplevel).v; \
	set TOPLEVEL $(toplevel); \
	set RUNTIME $(runtime); \
	set MAKEGEN $(makegen_tcl) 

.PHONY: prep vsim view clean all default

vpath t_%.erbv $(srcdir)
vpath %.erbv $(srcdir)

#ruby rules
$(srcdir)/t_%.v : t_%.erbv
	erb $< > $@

#verilog rules
$(srcdir)/t_%.erbv : %.erbv

all:prep

#generate the build directory
$(build_dir): $(targetVFiles) 
	echo $(targetVFiles);\
	mkdir $(build_dir);\
	echo -e "*\n!.gitignore" > $(build_dir)/.gitignore

#copy all the src files do the build directory and all the tcl files
prep: | $(build_dir) 
	cp $(tcl_files) $(build_dir)/;\
	cp $(toplevel).v $(build_dir)/;\
	echo '$(vsim_vars)' > $(build_dir)/$(makegen_tcl);\
	echo -e "*\n!.gitignore" > $(build_dir)/.gitignore

#simulation
vsim:prep
	cd $(build_dir); \
	vsim -c -do $(readin_tcl) ; \
	cd - ; \
	export PATH=/ad/eng/research/eng_research_icsg/mixed/bobzhou/software/tools/bin:$PATH;\
	echo -e "\n";\
	figlet -f basic -c sim success

#view waveforms
view:vsim
	cd $(build_dir); \
	vcd2wlf $(toplevel).vcd $(toplevel).wlf ; \
	vsim -view $(toplevel).wlf -do readWaveforms.tcl; \
	cd .. ; 

clean:
	rm -rf $(build_dir)/*
	echo -e "*\n!.gitignore" > $(build_dir)/.gitignore
