# HW1 — Storage I/O Benchmarking with FIO

**Course**: NYCU [CSIC30155] Memory and Storage System
**Due**: April 16, 2026

## Overview

Use [fio (Flexible I/O Tester)](https://fio.readthedocs.io/en/latest/fio_doc.html) to benchmark a storage device under various I/O patterns and analyze the results.

## Questions

| File | Topic | Weight |
|------|-------|--------|
| `q0.fio` | Example: sequential read baseline | 10% |
| `q1.fio` | Sequential read vs. random read | 10% |
| `q2.fio` | Sequential write vs. random write | 10% |
| `q3.fio` | Forward write vs. backward write | 10% |
| `q4/` | Buffered vs. non-buffered read (sequential + random) | 15% |
| `q5.fio` | LBA offset effect on bandwidth | 10% |
| `q6.fio` | Block size effect (4K vs. 1K) | 15% |
| `q7.fio` | Fastest 1 GB non-buffered read | 20% |
| `bonus/` | Multi-device comparison + spec verification | +10% |

## Running

```shell
fio <jobfile>.fio
```

All job files use `direct=1` (non-buffered I/O) unless otherwise noted.
Set `filename=` to your target device or test file path before running.

## Submission

Report: `314540025_report.pdf`
Archive: `HW1_314540025.zip`
