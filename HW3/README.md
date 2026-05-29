# HW3 — LLM Offloading and Memory Hierarchy Observation

**Course**: NYCU [CSIC30155] Memory and Storage System
**Due**: June 1, 2026

## Overview

Use [FlexGen](https://github.com/FMInference/FlexLLMGen) to observe how distributing `facebook/opt-1.3b` weights across GPU / CPU RAM / Disk affects throughput, memory usage, and I/O patterns.

## Hardware Used

| Component | Spec |
|-----------|------|
| GPU | NVIDIA GeForce RTX 5080 (16 GB) |
| CPU | Intel Core Ultra 9 285K (24 cores) |
| RAM | 125 GB |
| Disk | NVMe SSD (nvme1n1), ~537 GB free |
| Path | Local (not Colab) |

## Setup

```shell
conda env create -f environment.yml
conda activate flexgen-lab

git clone https://github.com/FMInference/FlexLLMGen.git
cd FlexLLMGen && pip install -e . && cd ..

mkdir -p logs flexgen_offload
```

Model weights (~2.8 GB) are downloaded automatically on first run to `~/opt_weights/opt-1.3b-np/`.

## Experiments

### Q1 — Progressive Offload Sweep (`--gpu-batch-size 4`)

| Setting | `--percent` | Throughput (tok/s) | Peak GPU Mem (GB) |
|---------|-------------|--------------------|--------------------|
| (1) 100% GPU | `100 0 100 0 100 0` | 277.07 | 2.829 |
| (2) 50% GPU + 50% CPU | `50 50 100 0 100 0` | 95.74 | 1.705 |
| (3) 50% GPU + 50% Disk | `50 0 100 0 100 0` | 23.06 | 1.737 |
| (4) 50% CPU + 50% Disk | `0 50 100 0 100 0` | 20.75 | 0.610 |
| (5) 100% Disk | `0 0 100 0 100 0` | 14.67 | 0.610 |

### Q2 — Batch Size Sweep (100% Disk)

| Batch | Wall Time (s) | Throughput (tok/s) | Peak GPU Mem (GB) |
|-------|---------------|--------------------|-------------------|
| b=1   | 4.430 | 3.61  | 0.493 |
| b=4   | 4.362 | 14.67 | 0.610 |
| b=16  | 4.393 | 58.28 | 1.072 |

### Q3 — Weight Compression (`--compress-weight`)

| Scenario | Compress? | Throughput (tok/s) | Peak GPU Mem (GB) |
|----------|-----------|--------------------|--------------------|
| (α) 100% GPU  | No  | 277.07 | 2.829 |
| (α) 100% GPU  | Yes | 122.17 | 1.125 |
| (β) 100% Disk | No  | 14.67  | 0.610 |
| (β) 100% Disk | Yes | 19.56  | 0.491 |

### Q4 — I/O Behavior and Bottleneck Analysis

**Part 1 — iostat (100% Disk, nvme1n1)**

| Metric | Peak Value |
|--------|-----------|
| r/s | 59.49 req/s |
| rkB/s | 3,446 KB/s |
| rareq-sz | 57.93 KB/req |
| %util | 40.5% |

Pattern: **Sequential, large blocks** (rareq-sz ≥ 32 KB — kernel readahead active).

**Part 2 — Stage Timings (`--debug-mode breakdown`)**

| Scenario | load_weight (s/layer) | compute_decoding (s/batch) | load/compute |
|----------|-----------------------|----------------------------|--------------|
| (1) 100% GPU  | 0.000011 | 0.005151 | 0.0021 |
| (5) 100% Disk | 0.005538 | 0.005079 | 1.090  |

## Running Experiments

```shell
# Q1 — all 5 settings
python -m flexllmgen.flex_opt --model facebook/opt-1.3b \
    --percent 100 0 100 0 100 0 --gpu-batch-size 4 \
    --prompt-len 128 --gen-len 16 --offload-dir flexgen_offload \
    2>&1 | tee logs/q1_1.log
# (repeat for each --percent config, saving to q1_2.log ... q1_5.log)

# Q4 Part 1 — parallel monitoring
iostat -x 1 > logs/q4_1_io_iostat.log &
free -m -s 1 > logs/q4_1_io_free.log &
python -m flexllmgen.flex_opt --model facebook/opt-1.3b \
    --percent 0 0 100 0 100 0 --gpu-batch-size 4 \
    --prompt-len 128 --gen-len 16 --offload-dir flexgen_offload \
    2>&1 | tee logs/q4_1_run.log
# After finish: kill the background iostat/free processes
```

See `monitor.sh` for the convenience wrapper used in Q4 Part 1.

## Logs

All experiment logs are in `logs/`. Required submission logs:

| File | Description |
|------|-------------|
| `logs/q4_1_io_iostat.log` | iostat -x 1 during disk offload run |
| `logs/q4_1_io_free.log` | free -m -s 1 during disk offload run |
| `logs/q4_2_baseline.log` | breakdown timing — 100% GPU |
| `logs/q4_2_disk.log` | breakdown timing — 100% Disk |

## Report

- Source: `report.tex`
- Compiled: `report.pdf`
