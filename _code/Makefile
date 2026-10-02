# Adaptado del Makefile de silence-db. Solo proyectos migrados de req2sql.
MYSQL ?= mariadb
DBS := usuarios aficiones-est aficiones-din pedidos empleados apartamentos animales

.PHONY: help load-all run-tests $(addprefix load-,$(DBS)) $(addprefix test-,$(DBS))
help:
	@echo "make -C _code load-<proyecto> | test-<proyecto> | load-all | run-tests"
	@echo "MYSQL permite configurar el cliente y sus opciones de conexión."

load-all: $(addprefix load-,$(DBS))
run-tests: $(addprefix test-,$(DBS))

$(addprefix load-,$(DBS)): load-%:
	cd "$*" && $(MYSQL) --abort-source-on-error < loadDB.sql

$(addprefix test-,$(DBS)): test-%:
	cd "$*" && $(MYSQL) --abort-source-on-error < runTests.sql
