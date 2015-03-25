default: all

#build dir org
basedir		:= .
srcdir		:= src
tcldir		:= config
includedir  := $(srcdir)

#tcl files
makegen_tcl := generated_vars.tcl
readin_tcl  := t_.tcl
wave_tcl	:= readWaveforms.tcl
tcl_files	:= $(readin_tcl) $(wave_tcl) $(makegen_tcl)

#simulate rules
#################################################################
toplevel 	:= top
runtime		:= 10ns
#################################################################

# define build directory
build_dir	:= current
# specify the variables in tcl file
vsim_vars	:= \
	set INCLUDE_DIR $(includedir); \
	set TOP	$(toplevel).v; \
	set TOPLEVEL $(toplevel); \
	set RUNTIME $(runtime); \
	set MAKEGEN $(makegen_tcl); \

all: vsim

prep:
	cd $(tcldir)/ \
	cp $(tcl_files) ../$(build_dir)/\
	cd -\
	cd $(srcdir)/\
	cp *.v ../$(build_dir)/\
	cd -\
	echo '$(vsim_vars)' > $(build_dir)/$(makegen_tcl)\
	echo -e "*\n!.gitignore" > $(build_dir)/.gitignore

vsim:prep
	cd $(build_dir); \
	vsim -c -do $(readin_tcl) ; \
	cd .. ; 

view:vsim
	cd $(build_dir); \
	vcd2wlf $(toplevel).vcd $(toplevel).wlf ; \
	vsim -view $(toplevel).wlf -do readWaveforms.tcl; \
	cd .. ; 

clean:
	rm -rf $(build_dir)/*
	cp $(srcdir)/.gitignore $(build_dir)
