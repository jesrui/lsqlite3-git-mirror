# makefile for lsqlite3 library for Lua

# dist location
DISTDIR=$(HOME)/dist
TMP=/tmp

# change these to reflect your Lua installation
LUA= /usr/local
LUAINC= $(LUA)/include
LUALIB= $(LUA)/lib
LUABIN= $(LUA)/bin
LUALUA= $(LUA)/lua

SQLITE= . #../sqlite

# no need to change anything below here
CFLAGS= $(INCS) $(DEFS) $(WARN) -O2 $(SHFLAGS)
#SHFLAGS= -fPIC
SHFLAGS=
WARN= -Wall #-ansi -pedantic -Wall
INCS= -I$(LUAINC) -I$(SQLITE)
#LIBS= -L$(LUALIB) -L$(SQLITE) -lsqlite3 -llualib5 -llua5
LIBS= -L$(LUALIB) -L$(SQLITE) $(LUABIN)/sqlite3.dll -llua51

MYNAME= sqlite3
MYLIB= l$(MYNAME)
VER=0.1-devel
TARFILE = $(DISTDIR)/$(MYLIB)-$(VER).tar.gz

OBJS= $(MYLIB).o
#T= $(MYLIB).so
T= $(MYLIB).dll

all: $T

test: $T
	$(LUABIN)/lua.exe test.lua

$T:	$(OBJS)
	$(CC) $(SHFLAGS) -o $@ -shared $(OBJS) $(LIBS)

clean:
	rm -f $(OBJS) $T core core.* a.out

dist:
	@echo 'Exporting...'
	@cvs export -r HEAD -d $(TMP)/$(MYLIB)-$(VER) $(MYLIB)
	@echo 'Compressing...'
	@tar -zcf $(TARFILE) -C $(TMP) $(MYLIB)-$(VER)
	@rm -fr $(TMP)/$(MYLIB)-$(VER)
	@lsum $(TARFILE) $(DISTDIR)/md5sums.txt
	@echo 'Done.'
