# MEC Lab Unix Collaborative Scratchpad

## Connecting to the cluster for the first time
- step 1: request access to cluster http://wiki.umassrc.org/wiki/index.php/Requesting_Access
- step 2: get an email with your user name and password
- step 3: download and install putty from https://www.chiark.greenend.org.uk/~sgtatham/putty/
- step 4: open putty
- step 5: type ghpcc06.umassrc.org into  "Host Name (or IP address)" box make sure port is set to 22 and connection type SSH is seldcted and click open
- step 6: type your user name into login as:
- step 7: type your given password NOTE: you will not be able to see anything appearing as you type your pw but you are still typing, press enter when you are done
- step 8:type your given password again
- step 9: type new password (Your password must contain:at least 9 characters, at least one digit, at least one other character (non alpha numeric))
- step 10: type new password again
- step 11: it will disappear, don't panic
- step 12: open putty again and type ghpcc06.umassrc.org into  "Host Name (or IP address)" box and click open
- step 13: type your new user name
- step 14: type your new password (you just set)
- step 15: You're ready to go!
## Basic Coding Tips For Beginners

When you are typing in your password, you won't be able to see anything, not even those little dots, but you are still typing.

Copy and Paste:

In the browser, highlight the desired text and do a regular copy (ctrl + c)
Paste in the working directory with one right click

Copying from the cluster: highlight the desired text, it will automatically copy

**It is always best to make your command line in  notepad/hackMD beforehand so you do not accidentally submit a job (LK:Can also use 'echo': great way for it to tell you what it is about to do before you actually do it)
**Clicking the right mouse button twice will act as an enter and submit your line of code, not paste your code

- enter info about sftp clients (Filezilla and CyberDuck)
- enter links to MGHPCC intro slides and wiki for references

### Making scripts 
- make in a text editor and save as xxxscript.sh
    - Text editors to download:
https://atom.io/
https://www.barebones.com/products/textwrangler/
- all scripts begin with ```#!/bin/bash``` 
- you can then transfer it to your cluster account using file zilla
- you can also create a script in console using ```touch xxxscript.sh```
- you can edit your script in console with ```nano xxxscript.sh```
- you can read your script in console using the command ```less xxxscript.sh``` 
- to be run your script in command line first run ```chmod u+x xxxscript.sh``` then run ```./path/xxxscript.sh```
- to submit a script as a job (see below for more details about bsub) to the cluster run ```bsub < ./path/xxxscript.sh```
## Uploading to the cluster and sharing files

Lisa: uploaded files to cluster
```
rsync -av -e ssh ./*fastq.gz lk17a@ghpcc06.umassrc.org:/home/lk17a/scratch/
rsync -av -e ssh ./test.sh lk17a@ghpcc06.umassrc.org:/home/lk17a/scratch/
```
- can use scp or rsync; see MGHPCC wiki; also I think if want to upload folders with multiple file, rsync only works (LK follow up/check)
- there is a Box app for rsync that might be useful to look into-LK has info from MGHPCC IT support-in email-insert here...


Shreya used this code to make a file and send it to Abby through the cluster
```  
cd test_folder
touch sendtoabby.txt
rsync -av -e ssh /home/sb86a/test_folder/sendtoabby.txt at55a@ghpcc06.umassrc.org:/home/at55a/home
```
and it showed up in abby's home folder
rsync = command, -av -e are controls so I had to say yes, ssh /home/sb86a/test_folder/sendtoabby.txt = what I wanted to send, at55a@ghpcc06.umassrc.org:/home/at55a/ where I want to send it to
PROBLEM: Abby had to type her password into my command line window before the file could be sent to her home directory

Lisa sent a file to SB
``` 
rsync -av -e ssh ./Chmy-48414C1277_S5_L001_R1_001.fastq.gz sb86a@ghpcc06.umassrc.org:/home/sb86a/test_folder
```
This also worked with SB's password entry

NOTE about rsync:
This creates copies, we are not sharing one file. This is good because we cannot accidentally delete a file from all of our accounts. We need to be aware that one person's work on a file in their account will not update the file in other accounts.

The following lines of codes were used to transfer files from Lisa to Abby and Shreya
```
scp ./*fastq.gz /project/uma_lisa_komoroske
mv ./NEB.adaptor.fasta /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB

rsync -av -e ssh ./*fastq.gz at55a@ghpcc06.umassrc.org:/home/at55a/Chmy_fq/
rsync -av -e ssh ./*fastq.gz sb86a@ghpcc06.umassrc.org:/home/sb86a/testfolder2/
```

You can also use filezilla to drag and drop files from your cluster folders to your home folders!

## Submitting a job 


Then use the bsub command to submit jobs to the cluster. 
```
#cd your.working.directory
bsub -q long -W 1:00 -R rusage[mem=16000] -n 4 -R span\[hosts=1\] #command# #FILENAME#
```
The following are options for job requests:
```
   #BSUB -n X                   # Where X is in the set {1..X}
   #BSUB -J Bowtie_job          # Job Name
   #BSUB -o myjob.out           # Append to output log file
   #BSUB -e myjob.err           # Append to error log file
   #BSUB -oo myjob.log          # Overwrite output log file 
   #BSUB -eo myjob.err          # Overwrite error log file 
   #BSUB -q short               # Which queue to use {short, long, parallel, GPU, interactive}
   #BSUB -W 0:15                # How much time does your job need (HH:MM)
   #BSUB -L /bin/sh             # Shell to use
   #BSUB -R span\[hosts=1\]     #says you want to use cores on the same host!
   #BSUB -R rusage[mem=16000]   # max amount of memory the cluster will use (in megabytes! so 16000 = 16GB)
   #BSUB -n 1                   # specifies number of cores you want to use
```
Currently the smallest memory nodes in the long queue have 128G of memory, the largest 512G, so you can specify larger amounts, though the tradeoff tends to be a longer time pending for resources before the job can be dispatched.

The following code will submit a job (of the simple command pwd) to the cluster!

```
bsub -q long -W 1:00 -R rusage[mem=10240] -n 1 pwd
```
To check job status and job number of all jobs you currently have running use:
```
bjobs 
```
To kill a job use: 
```
bkill xxxx
# xxxx = your job number
```
The following code submitted jobs for fastqc on our rna seq files that ran successfully!
```
bsub -q long -W 1:00 -R rusage[mem=16000] -n 4 -R span\[hosts=1\] fastqc Chmy-EEA723-619_S1_L001_R1_001.fastq.gz
```

We now see a .zip file and a .html file for the files we ran fastqc on in our wdirs.

Now we want to download the .html and  .zip folders to our home computer so we can view them in a useful way.

Instructions
1. Download filezilla https://sourceforge.net/projects/filezilla/
2. look at the top bar on the program
    Host: ghpcc06.umassrc.org
    Username: #USERNAME#
    Password: #PASSWORD#
    Port: 22
3. Click Quickconnect. The right column should populate with your cluster files
4. right click on the HTML report desired, then click view/edit

## Running Fast QC on all files in one command

As always make sure you are in the correct directory

```
module load fastqc/0.11.5 
for i in *qt.fastq.gz ; do bsub -q long -W 4:00 -R rusage[mem=16000] -n 1 -R span\[hosts=1\] fastqc "$i" ; done
```
Watch out for added characters from hack md (even though this shouldn't happen) and if you get wierd characters in your emails just type out the command. 

If you're in the directory with all your input files you don't need to specify the path

The above loop submits nine separate jobs (one for each file) and results in nine different emails.
 
##### Alternately, a quick bash script loop would be (reference for later steps):
From Lisa:

(this would be your bash script)
```
#!/bin/bash
#run fastqc

module load fastqc/0.11.5

for file in *qt.fastq.gz

do

sample=`echo $file | cut -f1 -d "." `

echo $sample

bsub -q long -W 1:00 -R rusage[mem=16000] -n 4 -R span\[hosts=1\] fastqc -f fastq.gz "$sample".fastq.gz > fastqc.stdout 2> fastqc.stderr

done
```
save as FastQC.sh

-upload script to your directory and then make it executable

```
chmod u+x FastQC.sh
```
Then run script 

```
./FastQC.sh
```
## Run MultiQC

Shreya emailed support to have them load multiqc to the ghpcc.

```
#make sure you are in the wdir with your fastq.gz files
module load python3/3.5.0_packages/multiqc/1.4
bsub -q long -W 1:00 -R rusage[mem=1000] -n 4 -R span\[hosts=1\] multiqc .
# . tells the command to search the current directory
# can use --ignore sample.name to skip a sample
# avg mem used = 37MB so can probs request less memory
```
multiqc_report.html is now in my wdir! there is also a new wdir within my wdir called mutliqc data.

How to look at the report:
1. Open filezilla (or download at https://sourceforge.net/projects/filezilla/)
2. look at the top bar on the program
    Host: ghpcc06.umassrc.org
    Username: #USERNAME#
    Password: #PASSWORD#
    Port: 22
3. Click Quickconnect. The right column should populate with your cluster files
4. right click on the HTML report desired, then click view/edit

#### Yay!
## Next step: trimming!

Adapter and Quality Trimming:
[Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

Steps
1. Transfer adaptor files from PC to your cluster
2. load Trimmomatic
```
module load trimmomatic/0.32
```
     
#### Running trimmomatic for one sample (paired end):
```

module load trimmomatic/0.32 

java -jar /share/pkg/trimmomatic/0.32/trimmomatic-0.32.jar PE -phred33 Chmy-151544493A_S4_L001_R1_001.fastq.gz Chmy-151544493A_S4_L001_R2_001.fastq.gz Chmy-151544493A_R1_qt.fastq.gz s1_se Chmy-151544493A_R2_qt.fastq.gz s2_se ILLUMINACLIP:NEB.adaptor.fasta:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:2 MINLEN:25

bsub -q long -W 48:00 -R rusage[mem=16000] -n 1 -R span\[hosts=1\] -e trim2.err < /home/sb86a/scripts/trim2.sh

```

- All samples
    - The next step is to run all the samples together, so we take the same command and just paste in the key for 'sample' into the loop. So the code below would be put into a little bash script, like trim_loop.sh. You can comment out the actual command the before you run to test and see if it tells you the names of the files and samples you expect (because we have the echo's in there). 

#### Running all samples in a Loop:

```
#navigate to the appropriate directory

touch trim_loop.sh #then copy and paste code below

##########################
#module load trimmomatic/0.32

for file in ./*R1_001.fastq.gz

do

echo $file

sample=`echo $file | cut -f1 -d "_"` 

echo $sample
   
#java -jar /share/pkg/trimmomatic/0.32/trimmomatic-0.32.jar PE -phred33 "$sample"_S4_L001_R1_001.fastq.gz "$sample"_S4_L001_R2_001.fastq.gz "$sample"_R1_qt.fastq.gz "$sample"_s1_se.fastq.gz "$sample"_R2_qt.fastq.gz "$sample"_s2_se.fastq.gz  ILLUMINACLIP:NEB.adaptor.fasta:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:2 MINLEN:25

done
```

- This is what you then put into the command line:
```
bsub -q long -W 4:00 -R rusage[mem=16000] -n 1 -R span\[hosts=1\] -e trim.err < ./trim_loop.sh 
```

- After you confirm, you can remove the # and run for real.
    - *(First you need to make your script executable-thats what the chmod does)*
```
chmod u+x trim_loop.sh
ls -lh #to check-now your script should have an "x" in the left column, and likely will show up as a different color

bsub -q long -W 4:00 -R rusage[mem=16000] -n 1 -R span\[hosts=1\] -e trimloop.err < ./trim_loop.sh
```
## Concatenate files together for de novo assembly
```
cat Chmy-132336657A_R1_qt.fastq.gz Chmy-151544493A_R1_qt.fastq.gz Chmy-EEA723-619_R1_qt.fastq.gz Chmy-151542322A_R1_qt.fastq.gz Chmy-48414C1277_R1_qt.fastq.gz > ./Combined.files/combined_R1_qt.fastq.gz

cat Chmy-132336657A_R2_qt.fastq.gz Chmy-151544493A_R2_qt.fastq.gz Chmy-EEA723-619_R2_qt.fastq.gz Chmy-151542322A_R2_qt.fastq.gz Chmy-48414C1277_R2_qt.fastq.gz > ./Combined.files/combined_R2_qt.fastq.gz

gunzip combined_R2_qt.fastq.gz >combined_R2_qt.fastq
gunzip combined_R1_qt.fastq.gz >combined_R1_qt.fastq
#check that came out the other side with the same line #s; note that the #s won't match necessarily in the .gz versions due to the compression algorithm
wc -l combined_R2_qt.fastq 
#1498760192 combined_R2_qt.fastq
wc -l combined_R1_qt.fastq 
#1498760192 combined_R1_qt.fastq
```


## De novo assembly with Trinity
### install trinity (but you can also use module load)
```
wget https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.3.2.tar.gz 

tar xzf Trinity-v2.3.2.tar.gz
```
#### Notes about Trinity
- Trinity runs on unzipped .fq files
- Trinity is a memory intensive proccess. You likely cannot complkete a job from your home directory and will need to be working from ```/project/uma_lisa_komoroske/...```
- Trinity documentation estimates using about 1G of RAM per 1 million reads and 1 hour of run time per 1 million reads. To count the number of reads in your fq file use the code ```wc -l ./file.fq``` your left and right .fq files should have the same number of lines (your left and right .gz files may have different numbers of lines, this is okay.)
- If you have a large data set, be sure to use the --normalize_reads parameter to greatly improve run times, although this is the default setting.
- you can reduce the total RAM requirements by running Trinity with parameter '--min\_kmer\_cov 2'. Although the assembly should still be of high quality and require less RAM, lowly expressed transcripts may be more highly fragmented in the assembly. (kept for future reference but we do not want to use this option)
- Trinity used checkpoints so if the job hits its wall time and is killed before it finishes you can start it back up from the exact same directory and have it use and output to the exact same files to pick up where it left off!


### Running Assembly on contatenated trimmed files
- slight changes from Trisha's suggestions on specifying cores and memory etc
- ```-n 35,64``` tells the cluster to use at least 35 cores and up to 64 as available
- If you specify an ouput log with ```-oo job.log``` you will not recieve an email when your job is finished or killed soremember what you put your wall time is and check your log to see what is going on
- Trinity default is to normalize reads so don't really need that in there but just put to remind that it's doing that
- The ```--max_memory xxxG``` and ```--CPU xx``` options within the trinity command must specified. ```--max_memory xxxG``` must be less than the max memory you request through your ```-R rusage[mem=xxx]``` code and ```--CPU xx``` must be less than the number of cores you reques with your ```-n xx``` code
```
# (cd to dir with fastq files)
mkdir assembly_combinedfiles
cd assembly_combinedfiles
module load trinity/2.2.0
module load bowtie2/2.3.2
module load java/1.8.0_31
module load samtools/1.4.1

bsub -q long -W 300:00 -n 35,64 -R span[hosts=1] -R rusage[mem=10000] -oo ../comb_assem.log  /share/pkg/trinity/2.2.0/Trinity --left ../combined_R1_qt.fastq --right ../combined_R1_qt.fastq --seqType fq -max_memory 300G --CPU 30 --output Trinity_combined_assembly --normalize_reads
``` 
## Mapping reads to our assembly with salmon
### Install salmon and set up
```
cd /project/uma_lisa_komoroske/bin
wget https://github.com/COMBINE-lab/salmon/releases/download/v0.8.2/Salmon-0.8.2_linux_x86_64.tar.gz 

tar xvfz Salmon-0.8.2_linux_x86_64.tar.gz
```

### Build an index for your new transcriptome:

make an index script 
```
touch index.sh.2
nano index.sh.2
```
copy and paste 
```
#!/bin/bash
#run salmon index
salmon=/project/uma_lisa_komoroske/bin/Salmon-0.8.2_linux_x86_64/bin/salmon 
$salmon index -t /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/Combined.files/assembly_combinedfiles/Trinity_combined_assembly/Trinity.fasta -i Cm_index
```
submit script
```
bsub -q long -W 20:00 -R rusage[mem=16000] -n 10 -R span\[hosts=1\] -e index.err < ./index.sh.2
```
Resource usage summary:

    CPU time :                                   500.65 sec.
    Max Memory :                                 11901 MB
    Max Processes :                              4
    Max Threads :                                14
    Run time :                                   476 sec.
   
### Run Salmon on one file
make a salmon script 
```
cd /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/quant
touch salmon1.C.sh
nano salmon1.C.sh
```
Copy and paste
```
#!/bin/bash
#run salmon 
salmon=/project/uma_lisa_komoroske/bin/Salmon-0.8.2_linux_x86_64/bin/salmon
index=/project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/quant/Cm_index
left=/project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/Chmy-132336657A_R1_qt.fastq.gz
right=/project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/Chmy-132336657A_R2_qt.fastq.gz
dir=/project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/quant/Chmy-132336657A_quant
$salmon quant -i $index --libType A -1 $left -2 $right -p 8 -o $dir
```
submit script
```
cd /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/quant
bsub -q long -W 20:00 -R rusage[mem=16000] -n 10 -R span\[hosts=1\] -e salmon1.C.err < ./salmon1.C.sh
```
Resource usage summary:

    CPU time :                                   4772.29 sec.
    Max Memory :                                 8769 MB
    Max Processes :                              4
    Max Threads :                                17
    Run time :                                   637 sec.

Notes

- script did not work when salmon command not all one line (/enter between sections of command did not work)
- Auto library type said our libraries are IU (inward unstranded)
- can map .gz files, no need to unzip

### Run Salmon on all files
Make your script
```
cd /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/quant_scripts
touch salmon_loop.SB.sh 
nano salmon_loop.SB.sh
```
copy and paste 
```
#!/bin/bash
#run salmon
salmon=/project/uma_lisa_komoroske/bin/Salmon-0.8.2_linux_x86_64/bin/salmon
index=/project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/quant/Cm_index
for R1 in *R1_qt.fastq.gz
  do
    sample=$(basename $R1 _R1_qt.fastq.gz)
    echo sample is $sample, R1 is $R1
    R2=${R1/R1/R2}
    echo R2 is $R2
  $salmon quant -i $index --libType A -1 $R1 -2 $R2 -p 8 -o ./quant_loop_output/${sample}_quant
  done
 ```
#### test script with #command to make sure loop is cutting sample names correctly then remove # to bsub
submit your script
```
cd /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB
bsub -q long -W 8:00 -R rusage[mem=6000] -n 10 -R span\[hosts=1\] -e ./quant_scripts/salmon_loop.SB.err < ./quant_scripts/salmon_loop.SB.sh
```
Resource usage summary:

    CPU time :                                   26657.00 sec.
    Max Memory :                                 8793 MB
    Max Swap :                                   2 MB
    Max Processes :                              4
    Max Threads :                                17
    Run time :                                   3454 sec.

## Annotation with Dammit

### Installing dammit with help from mghpcc tech support
Their instructions:
Installing into project space involves changing the command "conda create -n dammit python=3" and "source activate dammit" to:

```
module load anaconda2/4.4.0
conda create --prefix /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/annotation/dammit python=3
source activate /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/annotation/dammit

conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda install dammit
```
To use it in the future:
```
module load anaconda2/4.4.0
source activate /project/uma_lisa_komoroske/bin/dammit
```
After installing, it's possible to abbreviate the environment using a symlink:
```
ln -s /project/your_project_space/dammit ~/.conda/envs/dammitp
ln -s /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/annotation/dammit ~/.conda/envs/dammitp
```
Where "dammitp" at the end can be any name you choose. You could then access it through:
```
module load anaconda2/4.4.0
source activate dammitp
```
### installing dammit into the bin folder
```
cd /project/uma_lisa_komoroske/bin
module load anaconda2/4.4.0
conda create --prefix /project/uma_lisa_komoroske/bin/dammit python=3
source activate /project/uma_lisa_komoroske/biny/dammit

conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda install dammit
source deactivate /project/uma_lisa_komoroske/biny/dammit
```
## Running Dammit

install all databases into bin:
``` 
###plug in computer and set to not sleep
bsub -q interactive -R "rusage[mem=51200]" -Is bin/bash
module load anaconda2/4.4.0
source activate /project/uma_lisa_komoroske/bin/dammit
dammit databases --install --database-dir /project/uma_lisa_komoroske/bin/dammit/databases
```

make an annotation script
```
#!/bin/bash

module load anaconda2/4.4.0

source activate /project/uma_lisa_komoroske/bin/dammit

Ref="/project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/assembly/assembly_combinedfiles/Trinity_combined_assembly/Trinity.combined.fasta"

DB_dir="/project/uma_lisa_komoroske/bin/dammit/databases"

dammit annotate $Ref --database-dir $DB_dir --busco-group tetrapoda --n_threads 12
```
and submit
```
cd /project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/annotation
SCRIPTS="/project/uma_lisa_komoroske/Shreya/CmRNAseq_SB/SB_scripts"
bsub -q long -W 48:00 -R rusage[mem=4000] -n 12,24 -R span\[hosts=1\] -e dammit_7.7.18.err < $SCRIPTS/dammit.sh
```

```
Successfully completed.

Resource usage summary:

    CPU time :                                   1245220.50 sec.
    Max Memory :                                 4762 MB
    Average Memory :                             1683.29 MB
    Total Requested Memory :                     120000.00 MB
    Delta Memory :                               115238.00 MB
    Max Swap :                                   2 MB
    Max Processes :                              31
    Max Threads :                                54
    Run time :                                   177128 sec.
    Turnaround time :                            177130 sec.
```
#### annotation seems to take about 100 hours with [mem=8000] and -n 12,24
## formatting dammit output

figure out location of your python program
```
module load anaconda2/4.4.0
source activate /project/uma_lisa_komoroske/bin/dammit
which python
```
update script 
```
#!/project/uma_lisa_komoroske/bin/dammit/bin/python
#formatting dammit output
import pandas as pd #load 'pandas' package and call it pd
from dammit.fileio.gff3 import GFF3Parser # import tool 'GFFSParser'
gff_file = "Trinity.combined.fasta.dammit/Trinity.combined.fasta.dammit.gff3"
annotations = GFF3Parser(filename=gff_file).read()
names = annotations.sort_values(by=['seqid', 'score'], ascending=True).query('score < 1e-05').drop_duplicates(subset='seqid')[['seqid', 'Name']]
new_file = names.dropna(axis=0,how='all')
new_file.head()
new_file.to_csv("Cm_gene_name_id.csv")
```
submit
```
bsub -q long -W 10:00 -R rusage[mem=1000] -n 8 -R span\[hosts=1\] -e dammit < ./gff3config.py
```
```
Successfully completed.

Resource usage summary:

    CPU time :                                   27.79 sec.
    Max Memory :                                 463 MB
    Average Memory :                             246.00 MB
    Total Requested Memory :                     8000.00 MB
    Delta Memory :                               7537.00 MB
    Max Swap :                                   -
    Max Processes :                              3
    Max Threads :                                12
    Run time :                                   30 sec.
    Turnaround time :                            50 sec.
```
