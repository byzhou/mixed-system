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

#src files
erbfiles	:= $(shell ls $(srcdir)/*.erb.v)
srcfiles	:= $(erbfiles:%.erb.v=%.v) 

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

.PHONY: prep vsim view clean all default

vpath %.erb.v $(srcdir)

$(srcdir)/%.v:%.erb.v
	erb $< > $@

all: $(srcfiles) 
	
prep: 
	cp $(tcldir)/$(tcl_files) $(build_dir)/\
	cp $(srcdir)/*.v ../$(build_dir)/\
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
