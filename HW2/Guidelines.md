---
title: 'Assignment II - Valgrind & Pytorch profiler'

---

# Assignment II - Valgrind & Pytorch profiler
**[NYCU \[CSIC30155\] Memory and Storage System](https://timetable.nycu.edu.tw/?r=main/crsoutline&Acy=114&Sem=2&CrsNo=535512&lang=zh-tw) by Prof. [Chun-Feng Wu](https://www.cs.nycu.edu.tw/members/detail/cfwu417)**

<font color="#f00"> **Due Date: 23:59, Monday, May 4, 2026** </font>

---
**Table of Contents**

[TOC]

---



## Goal of the assignment
- Learn how to profile processes (e.g., benchmark) by **Valgrind**
- Learn how to analyze model by **Pytorch profiler**



## Introduction
- Valgrind is an instrumentation framework for building dynamic analysis tools. It comes with a set of tools each of which performs some kind of debugging, profiling, or similar task that helps you improve your programs.
    - In this assigment, we'll practice four tools : Memcheck / Callgrind / Cachegrind / Massif


> The official website [valgrind](https://valgrind.org/docs/manual/manual.html), provides an introduction to tools that can help to complete this assignment.

- PyTorch includes a simple profiler API that is useful when user needs to determine the most expensive operators in the model.
    - In this assignment, we'll provide a model for you to conduct a simple analysis.



## Environment setup
Please run and implement all assignments on your own machine.
If you are not using Linux as host operating system, we strongly recommend you to install Linux in a virtual machine (e.g., VirtualBox, VMware) and run all assignments on it.

:::info
**Note**: We recommend using Linux as the operating system to finish this assignment.
:::



### Valgrind
Valgrind supports multiple environments, and testing environment is on Ubuntu 22.* Desktop, but of course, you can choose other preferred environments.
The following installation instructions are all for **Ubuntu**.
```shell
wget https://sourceware.org/pub/valgrind/valgrind-3.20.0.tar.bz2
tar -jxvf valgrind-3.20.0.tar.bz2
cd valgrind-3.20.0
./configure
make 
sudo make install
```

### Graph500
Benchmark installation for exercise 4
```
wget https://github.com/graph500/graph500/archive/graph500-2.1.4.tar.gz
tar -xvf ./graph500-2.1.4.tar.gz
mv graph500-graph500-2.1.4/ graph500-2.1.4/
cd ./graph500-2.1.4/
cp ./make-incs/make.inc-gcc ./make.inc

# ****** Not command ******
# edit your make.inc and remove -DUSE_MMAP_LARGE -DUSE_MMAP_LARGE_EXT 
# *************************
    
make
```

### kcachegrind
Analyzing tool for exercise 4
```shell
sudo apt update
sudo apt install kcachegrind
```
:::danger
**Warning**: kcachegrind is a software with a graphical user interface (GUI), so remoting to a host by VS Code SSH may fail to start kcachegrind.
:::


### Pytorch
Select preferences and follow the tutorial:
> https://pytorch.org/get-started/locally/



## Exercise
### 1. Memcheck - [30%]

First, you need to understand what types of errors can be detected by the **Memcheck**. Then, please use Memcheck to detect errors in the executable file **memleak** ,[X86-64-linux](https://drive.google.com/file/d/12SNOf9O2O-_aRiO-NhYeS_tDLbOsCGBk/view?usp=drive_link) | [arm64-linux](https://drive.google.com/file/d/1cnZUnRtJJyNlgX9Es3Y9ifBR9gYIPj3z/view?usp=sharing).

Run the following command, and you can get a log file containing information you need. 
```shell
valgrind --tool=memcheck --leak-check=full --log-file=<student ID>_log ./memleak
```

:::info
**Note**: If you face the error of permission denied, please use the command ```chmod 777 memleak```
:::


#### <font color="#f00"> Requirement: </font>

Please find out the errors from the log file. You should submit your <student ID>_log with annotations (see the picture below) and explain the errors in the report.

#### <font color="#f00">Hint:  </font>
- There are **6** major errors that need to be identified. It is acceptable to find more, but please ensure that the main errors are included.
- One of the errors is shown in the picture below.
![image](https://hackmd.io/_uploads/rylS5MZ-0.png)



### 2. Cachegrind - [10%]
First, you need to understand the meaning of messages reported in cachegrind's log file.
We provide two executable files [good](https://drive.google.com/file/d/192SmX-ZKvRRubEMO_meCuQWrHM_GoR1K/view?usp=sharing) & [bad](https://drive.google.com/file/d/1X6qTHlmwy3c_ATkBEaUpwX8XcrpnsTOW/view?usp=sharing) **(for X86-64)** / [good](https://drive.google.com/file/d/1kfNhbUikkOciTf1bfnljCEP_b1YV_ufC/view?usp=sharing) & [bad](https://drive.google.com/file/d/1nHPoL4FKYfDfEMqac8zoBljgJwC-5bwB/view?usp=sharing) **(for ARM64)**. The code of two files are almost the same, but there are some differences in log files.

Run the following command, you can get two log files.
```shell
valgrind --tool=cachegrind --log-file=[student.id]_good_log ./good 
valgrind --tool=cachegrind --log-file=[student.id]_bad_log ./bad
```
    
:::info
**Note**: If you face the error of permission denied, please use the command ```chmod 777 good bad```
:::


#### <font color="#f00"> Requirement: </font>
Please take screenshots of two logs and point out where the difference is and explain why this problem occurs in the report.

#### <font color="#f00">Hint:  </font>
In some cases, cachegrind may produce limited output when analyzing short-running programs. Adding ```--cache-sim=yes``` can help ensure a more detailed cache simulation.

### 3. Massif - [10%]
You need to understand how Massif operates and utilize it to test the program we provided ([heap.c](https://drive.google.com/file/d/12mIFRICflcA2O1qGuXuj02PnMsEo0A80/view?usp=sharing)).

Run the following command, and you'll get massif.out.[pid].
```shell
gcc -o heap heap.c
valgrind --tool=massif --time-unit=B ./heap
```

You may get some information from the output file.
```
ms_print massif.out.[pid]
```
#### <font color="#f00"> Requirement: </font>
    

1. [5%] Please observe the relationship between time and memory allocation throughout the **entire** program execution, and provide **one** screenshot of the output file containing relevant information. (You must clearly display the total number of **snapshots** each time the system records the information **in intervals**). 
2. [5%] Then, point out how many bytes are allocated and  used **at peak** respectively.



### 4. Callgrind - [20%]

Before starting this work, you may download the benchmark [Graph500](https://hackmd.io/rfkzc_-sRGeo8Cw-k50Y9A?view#Graph500), and the Analyzing tool, [kcachegrind](https://hackmd.io/rfkzc_-sRGeo8Cw-k50Y9A?view#kcachegrind). Then, you can enter Graph500 directory and run the command :
```shell
valgrind --tool=callgrind ./seq-csr/seq-csr -s 10 -e 12
```
you will get a callgrind.out.[pid], then run :
```shell
kcachegrind callgrind.out.[pid]
```
#### <font color="#f00"> Requirement: </font>
You need to answer the following two questions in your report :
1. [10%] Please use kcachegrind GUI to indicate which function is most expensive in terms of time (**excluding the time of their callee functions**). Please include a screenshot of the call graph.
2. [10%] Point out which function is called most frequently, and identify its caller as well. Please include a screenshot of the call graph.


:::info
**Note**: Note : If you need, here is the kcahcegrind quick guides :
https://kcachegrind.sourceforge.net/html/Documentation.html
:::


### 5. Pytorch profiler - [30%]
Before starting this work, you should have [Pytorch](https://hackmd.io/@Bmch4MS0Rz-VZWB74huCvw/S1Axz6QQh#Pytorch) installed.
Since large language models (e.g., ChatGPT) are famous nowadays, you might want to analyze some of them. 
    Here we provide a [transformer model](https://github.com/aladdinpersson/Machine-Learning-Collection/blob/master/ML/Pytorch/more_advanced/transformer_from_scratch/transformer_from_scratch.py). Please follow the [Pytorch Profiler Tutorials](https://pytorch.org/tutorials/recipes/recipes/profiler_recipe.html) to complete the following requirement.
:::info
**Note**: Use **CPU** as the device in this part.
:::
#### <font color="#f00"> Requirement: </font>
    
Please answer the following two questions in your report: 
Note that **only CPU** is allowed in this part (**No CUDA!!**).
1. [15%] Please follow the tutorial to get the columns shown in the picture below.
![image](https://hackmd.io/_uploads/BkTVafWbA.png)

    Please provide a screenshot of the analysis result, ensuring that the username and machinename are visible in the first line. Then, identify the top three functions in terms of CPU time excluding the time of their callee functions, **except for the model label** (e.g. model_inference in tutorials).
    
2. [15%] Output the profiling results to <output>.json and analyze in Chrome trace viewer. Take a screenshot of the visualization and point out **which two functions (colors)** appear the most (in terms of time), **except for the model label** (e.g. model_inference in tutorials).
    
#### <font color="#f00">Hint:  </font>
- To verify the answer for 5-2, you may draw inspiration from the approach used in 5-1.



## Submission
#### 1. Files
- Report: Only `.pdf` file is accepted
    - Make sure your report meets requirements
    - Filename
        - `<student ID>_report.pdf` (e.g `312551000_report .pdf`)
- Log file generated from Memcheck and Cachegrind part
    - Filename
        - `<student ID>_log` (e.g. `312551000_log`)
        - `<student ID>_good_log` (e.g. `312551000_good_log`)
        - `<student ID>_bad_log` (e.g. `312551000_bad_log`)


#### 2. Pack your report and log file

All your files should be organized in the following hierarchy and zipped into a `.zip` file, named HW2_<student ID>.zip (e.g. `HW2_312551000.zip`)

The structure inside the zipped file should be as the following:
```
HW2_<student ID>.zip 
    |- HW2_<student ID>/
        |- <student ID>_log
        |- <student ID>_good_log
        |- <student ID>_bad_log
        |- <student ID>_report.pdf
```

e.g.
```
HW2_312551000.zip 
    |- HW2_312551000/
        |- 312551000_log
        |- 312551000_good_log
        |- 312551000_bad_log
        |- 312551000_report.pdf
``` 
    

:::danger
**Warning**: If the file format is incorrect, there will be a 20% deduction.
:::

#### 3. Submit the archive through the E3 platform before deadline.
If you have any questions about this assignment, please feel free to contact with TA through email os.oscarlab@gmail.com