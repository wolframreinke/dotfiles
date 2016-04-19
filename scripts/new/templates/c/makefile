CC         = gcc                        # C-compiler&(FILENAME=Makefile)
CCFLAGS    = -g -c -std=c99             # C-compiler flags
CL         = gcc                        # Linker for C-programs
CLFLAGS    = -g                         # flags for C-linker

MKDIR      = mkdir -p

OBJDIR     = obj

# Object files for one of the executables.  Each executable should get one such
# variable:
$(echo "%(exec|name of the executable)" | tr [:lower:] [:upper:])OBJ = $$(OBJDIR)/%(exec).o


# The entirety of all of the variables above
OBJ       = $$($(echo "%(exec|name of the executable)" | tr [:lower:] [:upper:])OBJ)

$(echo "%(exec|name of the executable)" | tr [:lower:] [:upper:]) = %(exec)
TARGETS    = $$($(echo "%(exec|name of the executable)" | tr [:lower:] [:upper:]))

.PHONY: all
all: $$(TARGETS)

$$($(echo "%(exec|name of the executable)" | tr [:lower:] [:upper:])) : $$(OBJDIR) %(exec)exe
	

%(exec)exe : $$($(echo "%(exec|name of the executable)" | tr [:lower:] [:upper:])OBJ)
	$$(CL) $$(CLFLAGS) -o $$($(echo "%(exec|name of the executable)" | tr [:lower:] [:upper:])) $^

$$(OBJDIR):
	$$(MKDIR) $@

$$(OBJDIR)/%.o : %(src|source directory)/%.c
	$$(CC) $$(CCFLAGS) -o $@ $<

.PHONY: clean
clean:
	rm -rf $$(TARGETS) $$(OBJDIR)
