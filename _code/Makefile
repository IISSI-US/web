# Adaptado del Makefile de silence-db. Solo proyectos migrados de req2sql.
MYSQL ?= mariadb
DBS := usuarios aficiones-est aficiones-din pedidos empleados apartamentos animales proyectos espectaculos bodegas

.PHONY: help load-all run-tests test-usuarios-v2 $(addprefix load-,$(DBS)) $(addprefix test-,$(DBS))
help:
	@echo "make -C _code load-<proyecto> | test-<proyecto> | load-all | run-tests"
	@echo "MYSQL permite configurar el cliente y sus opciones de conexión."

load-all: $(addprefix load-,$(DBS))
run-tests: $(addprefix test-,$(DBS))

$(addprefix load-,$(DBS)): load-%:
	cd "$*" && $(MYSQL) --abort-source-on-error < loadDB.sql

$(addprefix test-,$(DBS)): test-%:
	cd "$*" && $(MYSQL) --abort-source-on-error < runTests.sql

test-usuarios-v2:
	cd usuarios && $(MYSQL) --abort-source-on-error < version2.sql
	cd usuarios && $(MYSQL) --abort-source-on-error < tests_v2.sql
