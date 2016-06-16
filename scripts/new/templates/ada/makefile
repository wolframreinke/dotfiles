ADAC       = gcc                        # Ada Compiler&(FILENAME=Makefile)
ADACFLAGS  = -g -c                      # Ada Compiler flags
ADAB       = gnatbind                   # GNAT bind command
ADABFLAGS  = -x                         # GNAT bind command flags
ADAL       = gnatlink                   # Linker for Ada programs
ADALFLAGS  =                            # Flags for Ada-linker

MKDIR      = mkdir -p

OBJDIR     = obj

# Object files for one of the executables.  Each executable should get one such
# variable:
$(echo "%(exec|name of the executable)" | tr [:lower:] [:upper:])OBJ = $$(OBJDIR)/%(exec).o
$(echo "%(exec)" | tr [:lower:] [:upper:])ALI = $$(OBJDIR)/%(exec).ali

# The entirety of all of the variables above

$(echo "%(exec)" | tr [:lower:] [:upper:]) = %(exec)
TARGETS    = $$($(echo "%(exec)" | tr [:lower:] [:upper:]))

.PHONY: all
all: $$(TARGETS)

$$($(echo "%(exec)" | tr [:lower:] [:upper:])) : $$(OBJDIR) %(exec)exe

%(exec)exe : $$($(echo "%(exec)" | tr [:lower:] [:upper:])OBJ) $$($(echo "%(exec)" | tr [:lower:] [:upper:])ALI)
	$$(ADAB) $$(ADABFLAGS) $$($(echo "%(exec)" | tr [:lower:] [:upper:])ALI)
	$$(ADAL) $$(ADALFLAGS) $$($(echo "%(exec)" | tr [:lower:] [:upper:])ALI)

$$(OBJDIR):
	$$(MKDIR) $@

$$(OBJDIR)/%.o $$(OBJDIR)/%.ali: %(src|source directory)/%.adb
	$$(ADAC) $$(ADACFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -rf $$(TARGETS) $$(OBJDIR)
