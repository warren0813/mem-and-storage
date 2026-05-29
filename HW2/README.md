# HW2 — Memory Profiling with Valgrind & PyTorch Profiler

**Course**: NYCU [CSIC30155] Memory and Storage System
**Due**: May 4, 2026

## Overview

Profile and analyze memory behavior using four Valgrind tools and the PyTorch profiler API.

## Exercises

| Exercise | Tool | Topic | Weight |
|----------|------|-------|--------|
| 1 | Memcheck | Detect memory errors in `memleak` binary | 30% |
| 2 | Cachegrind | Compare cache behavior of `good` vs. `bad` binaries | 10% |
| 3 | Massif | Heap memory usage over time for `heap.c` | 10% |
| 4 | Callgrind + kcachegrind | Call graph analysis of Graph500 benchmark | 20% |
| 5 | PyTorch Profiler | CPU profiling of a Transformer model | 30% |

## Directory Structure

```
scripts/
├── transformer_from_scratch.py   # PyTorch Transformer model (Ex. 5)
├── transformer_profile.json      # Chrome trace output
├── heap.c                        # Source for Massif exercise
├── memleak                       # Binary for Memcheck (x86-64)
├── good / bad                    # Binaries for Cachegrind comparison
└── logs/                         # Valgrind log outputs
```

## Running

```shell
# Ex. 1 - Memcheck
valgrind --tool=memcheck --leak-check=full --log-file=314540025_log ./scripts/memleak

# Ex. 2 - Cachegrind
valgrind --tool=cachegrind --log-file=314540025_good_log ./scripts/good
valgrind --tool=cachegrind --log-file=314540025_bad_log  ./scripts/bad

# Ex. 3 - Massif
gcc -o scripts/heap scripts/heap.c
valgrind --tool=massif --time-unit=B ./scripts/heap

# Ex. 4 - Callgrind (requires Graph500)
valgrind --tool=callgrind ./seq-csr/seq-csr -s 10 -e 12
kcachegrind callgrind.out.<pid>

# Ex. 5 - PyTorch Profiler (CPU only)
python scripts/transformer_from_scratch.py
```

## Log Files

| File | Description |
|------|-------------|
| `314540025_log` | Memcheck output |
| `31450025_good_log` | Cachegrind output for `good` binary |
| `31450025_bad_log` | Cachegrind output for `bad` binary |
