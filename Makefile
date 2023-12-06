-include .env
.EXPORT_ALL_VARIABLES:
MAKEFLAGS += --no-print-directory

NETWORK ?= ethereum-mainnet


install: clean
	foundryup
	forge install

tx:
	npx create-safe-tx

hash:
	forge script script/HashData.sol

sign\:%: hash
	forge script script/CheckNoSignature.sol
	cast wallet sign --$* $$(cat data/hashData.txt) 1>> data/signatures.txt
	@echo "\033[0;32mTx signature successfully appended to data/signatures.txt"

simulate\:%:
	forge script script/ExecTransaction.sol --$*

exec\:%:
	forge script script/ExecTransaction.sol --$* --broadcast

clean:
	mkdir -p data
	cp data/template.json data/tx.json
	> data/hashData.txt
	> data/signatures.txt


.PHONY: contracts test coverage hash sign simulate exec clean
