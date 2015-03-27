#=======================================================================
# Makefile for LowRISC tag tests
#-----------------------------------------------------------------------

default: all

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_PREFIX=riscv64-unknown-elf-
RISCV_GCC = $(RISCV_PREFIX)gcc
RISCV_LINUX_PREFIX=riscv-linux-
RISCV_LINUX_GCC = $(RISCV_LINUX_PREFIX)gcc
RISCV_GCC_OPTS = -I.. -O3
RISCV_LINUX_GCC_OPTS = -I.. -O3 -static

#--------------------------------------------------------------------
# Build targets
#--------------------------------------------------------------------

tag_tests = \
	tag_ld_st \
	parity \
	memory_sweep \

tag_tests_linux = $(addsuffix .linux, $(tag_tests))

#--------------------------------------------------------------------
# Build
#--------------------------------------------------------------------

$(tag_tests): %:%.cc ../env/tag.h
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $< -o $@

$(tag_tests_linux): %.linux:%.cc ../env/tag.h
	$(RISCV_LINUX_GCC) $(RISCV_LINUX_GCC_OPTS) $< -o $@


all: $(tag_tests)

linux: $(tag_tests_linux)

clean:
	rm -fr $(tag_tests) $(tag_tests_linux)
