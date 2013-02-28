CXX=g++
OPTIMIZE =  -O2
WARN = -Wall -Werror -Wno-deprecated
#DB4_BASE=/usr/local/db-4.8.26
#INCLUDES = -I$(DB4_BASE)/include
DEFINES=-DLINUX_BUILD -DBOOST_SPIRIT_THREADSAFE -DBOOST_SPIRIT_USE_OLD_NAMESPACE
CFLAGS = -pthread $(OPTIMIZE) $(WARN) $(INCLUDES) $(DEFINES) 
#LIBS = -L$(DB4_BASE)/lib -s -static -ldb_cxx-4.8 -ldb-4.8
LIBS = -ldb_cxx-4.3
includefile=depend
CSRCS:= BandwidthDb.cpp
PUSH_SRC=bwcounter bwdump daily_snapshot.sh
TPUSH_HOSTS=isl1.6waves.com
TPUSH_DEST=/home/virality/image_bw/bin/
PPUSH_HOSTS=$(shell cat image_servers.txt)
PPUSH_DEST=/home/virality/image_bw/bin/

OBJS = $(CSRCS:.cpp=.o)
all: bwcounter bwdump

bwcounter: $(OBJS) bwcounter.o
	$(CXX) -o $@ -g $(CFLAGS) $< bwcounter.o $(LIBS)
bwdump: $(OBJS)  bwdump.o
	$(CXX) -o $@ -g $(CFLAGS) $< bwdump.o $(LIBS)

%.o:%.cpp
	$(CXX) -c -g $(CFLAGS) $< -o $@
clean:
	rm -rf $(OBJS)
build: bwcounter bwdump
depend: 
	$(CXX) -M $(INCLUDES) $(CSRCS) > $(includefile)
include ../../make/push.mk
include depend
