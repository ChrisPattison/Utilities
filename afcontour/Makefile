F90=gfortran
LINK=$(F90)
VPATH=src:bin
BPATH=bin
SPATH=src
SRCS=$(shell ls src)
OBJS=$(SRCS:.f90=.o)

INCLUDE=
LIBS=


#FLAGS=-O3 -mfpmath=sse -march=native -Wall -Wtabs -m64
#FLAGS=-O3 -mfpmath=sse -march=native -Wall -Wtabs
FLAGS=-O2 -mfpmath=sse -march=native -Wall -Wtabs -ggdb -fcheck=all -ffpe-trap=invalid,zero,overflow -fbacktrace
#FLAGS=-O2 -mfpmath=sse -march=native -Wall -Wtabs -ggdb

EXE=main

ifeq ($(OS),Windows_NT)
	EXE=main.exe
endif

all: $(EXE)
main.o: kinds.o csv_file.o
geom.o: kinds.o

$(EXE): $(OBJS) Makefile
	@echo 'Linking [$(EXE)] from [$(OBJS)] using [$(LINK)]'
	@$(LINK) $(FLAGS) -o $(EXE) $(addprefix $(BPATH)/,$(OBJS)) $(LIBS)

%.o: %.f90 Makefile
	@echo 'Compiling [$@] from [$<] using [$(F90)]'
	@$(F90) $(FLAGS) $(INCLUDE) -J $(BPATH) -c $< -o $(BPATH)/$@

clean:
	@-rm $(BPATH)/* $(EXE)
	@-touch $(BPATH)/.keep
