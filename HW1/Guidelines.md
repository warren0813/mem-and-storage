---
title: 'Assignment I - FIO'

---

# Assignment I - FIO

**[NYCU \[CSIC30155\]] Memory and Storage System by Prof. [Chun-Feng Wu](https://www.cs.nycu.edu.tw/members/detail/cfwu417)**

<font color="#f00"> **Due Date: 23:59, April 16, 2026** </font>

---
[TOC]

---


## 1. Introduction to fio
Fio (Flexible I/O Tester) is an open-source tool for benchmarking and testing storage devices and file systems. It is a versatile tool that can simulate a variety of workloads and I/O patterns to help users evaluate the performance of their storage systems under different conditions. In this assignment, we will use the fio tool to test performance on your device using different I/O patterns. You may want to check [THIS_LINK](https://fio.readthedocs.io/en/latest/fio_doc.html) for detailed information about fio.

In this homework, you will be using your own device to conduct the experiment. Any storage device is fine to conduct the experiment as long as you could explain the results.

:::info
We recommend using Linux as the operating system to test on.
:::

---

## 2. Questions

### Q0. (10%) Example

Let's run an example to get familiar with fio. Here's a fio job file named ```q0.fio```
```
[global]
filename=<device name or file location eg. /dev/sdb>
bs=4k
size=1g
direct=1

[job1]
rw=read
```
You may check [JOB_FILE_FORMAT](https://fio.readthedocs.io/en/latest/fio_doc.html#job-file-format) and other parameters to realize the configuration above.

Run the folllowing command:
```
$ fio q0.fio > output
```
The output will be in the file `output`

:::info
If you use the disk directly, you might need to change the privilege level.
:::

<font color="blue">**Question :** </font>Please run ```q0.fio``` on your own device and write down your output ```q0``` in report. Also specify the type of drive that is used( HDD/SSD...).

You may check [THIS_LINK](https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output) to learn more about output. **However, we won't ask you to explain the output in detail**. To make things simple, we will focus only on the bandwidth and overall I/O latency, as shown below. You may just refer to the group statistics and compare them between different groups in the following questions.

### Q1. (10%) Read vs. Randread

In this part, you're required to compare sequential read and random read. Take a look at the `.fio` example below and use it to accomplish Q1.
```
[global]
filename=<your file location>
bs=4k
size=64m
direct=1
stonewall

[read]
...

[randread]
...
```

<font color="blue">**Question :** </font> Is there any significant difference between read/randread? Why or why not? Please justify your answer in brief. 

### Q2. (10%) Write vs. Randwrite

In this part, you're required to compare sequential write and random write.

:::danger
Warning: Writing directly to a disk could ruin the files that are in it. You could create a large file for testing purposes.
:::

<font color="blue">**Question :** </font> Is there any significant difference between write/randwrite? Why or why not? Please justify your answer in brief.

### Q3. (10%) Forward write vs. Backward write

In this part, you’re required to compare forward write and backward write. The definition of "backward" is to traverse blocks in a reverse order. For example, if there is only 11 blocks ranging from 0-10, then the block number you traverse forward is (0, 1, ..., 10), and the block number you traverse backward is (0, 10, 9, ..., 1).

<font color="blue">**Question :** </font>Is there any significant difference between forward/backward write? Why or why not? Please justify your answer in brief.

### Q4. (15%) Buffered read vs. Nonbuffered read
In this part, you’re required to compare sequential buffered read and sequential nonbuffered read.

<font color="blue">**Question :** </font>
1. (10%) Is there any significant difference between buffered/nonbuffered sequential read? Why or why not? Please justify your answer in brief.
2. (5%) Replace **sequential read** with **random read**. Is there any significant difference between buffered/nonbuffered random read? Why or why not? Please justify your answer in brief.


### Q5. (10%) LBA
Try to run `.fio` example below and observe the bandwidth.
```
[global]
filename=<your test location>
bs=1m
size=1g
rw=read
direct=1
stonewall

[job1]
offset=80%

[job2]
offset=60%

[job3]
offset=40%

[job4]
offset=20%

[job5]
offset=0
```

<font color="blue">**Question :** </font>Is there any bandwidth trend between these jobs? Why or why not? Please justify your answer in brief. You can also experiment with the size of the file.

### Q6. (15%) Blocksize

In this part, you’re required to compare 4k blocksize read and 1k blocksize read.

<font color="blue">**Question :** </font>
1. (10%) Is there any significant difference between 4k/1k read? Why or why not? Please justify your answer in brief.
2. (5%) If you want to achieve the best performance in the condition above, how would you modify ```blocksize```? Explain it briefly.

### Q7. (20%) Fastest nonbuffered read
In this part, you’re required to achieve the fastest 1G nonbuffered read. Take a look at the `.fio` example below and use it to accomplish Q7.

:::info
Note: [4k_bs] are just placeholders and do not indicate any restrictions on the variables.
:::
```
[global]
filename=<your test location>
direct=1
rw=read
size=1g
stonewall

[4k_bs]
...

[1k_bs]
...
```

:::info
Hint : you may refer to the questions before. Normally it would be no more than 30s
:::

<font color="blue">**Question :** </font>Please explain how you achieve the fastest 1G nonbuffered read in brief.

### Bonus (10%)

<font color="blue">**Question :** </font>
1. (5%) Compare with multiple kinds of storage devices
Is there any significant difference between read/randread on storage devices? Why or why not? Please justify your answer in brief.
2. (5%) Find the specs of your own hardware that you tested on
Is your hardware running to spec? If not, could you come up with a possible theory?

:::success
Note : The maximum score for this assignment is 100 points, so you are free to choose whether or not to write the bonus question.
:::

---
## 3. Grading Policy

* You will need to answer the questions in a `.pdf` report
* Please attach the `.fio` source code outside the report additionally

> :mag_right: Each question will be classified into one of the following four reward tiers: 
:one: excellent (100%)
:two: good (70%)
:three: bad (30%)
:four: fail (0%)

:::danger
:warning: **Attention**. You will get *NO POINT* when

* do not follow the submission rule including file name and format.
* cheating including any suspected plagiarism in source code or report.
:::

---

## 4. Submission
#### a. Pack your report and source code
* Report : **only** ```.pdf``` is accepted, should include the question and your explaination of what you have observed 
* Source code : ```q0.fio``` ~ ```q7.fio```, ```bonus/*.fio```
    * Multiple ```.fio``` files for each question is allowed (however you may avoid it). If you have multiple source files please create a folder for it.

All your files should be organized in the following hierarchy and zipped into a `.zip` file, named HW1_<student ID>.zip (e.g. `HW1_312551000.zip`)

Directory structure inside the zipped file:
```
HW1_<student ID>.zip
    |- HW1_<student ID>/
        |- <student ID>_report.pdf
        |- q0.fio
        |- q1.fio
        |- q2/
            |- q2_1.fio
            |- q2_2.fio
        |- q3.fio
        |- ...
        |- q7.fio
        |- bonus/
            |- other files
```

e.g.
```
HW1_312551000.zip
    |- HW1_312551000/
        |- 312551000_report.pdf
        |- q0.fio
        |- q1.fio
        |- q2/
            |-q2_1.fio
            |-q2_2.fio
        |- q3.fio
        |- q4.fio
        |- q5.fio
        |- q6.fio
        |- q7.fio
        |- bonus/
            |- bonus.fio
``` 
    
    

#### b. Submit the archive through the E3 platform before deadline.

If you have questions regarding the assignment, please reach out to the TA through the Discussion Forum on E3. 