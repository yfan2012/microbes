import os

print 'Running link'

datadir='/home-4/yfan7@jhu.edu/scratch/class/microbes/final'
infopath='/home-4/yfan7@jhu.edu/work2/FA17_Methods_dir/class_raw_data/sprehei1_132645_HISEQ_Mystic_Aug/primer_sample_pairs.csv'
seqpre='/home-4/yfan7@jhu.edu/work2/FA17_Methods_dir/class_raw_data/sprehei1_132645_HISEQ_Mystic_Aug/HC3YKBCXY_1_'

with open(infopath) as f:
    content=f.readlines()

seqinfo=[]
for i in content:
    seqinfo.append(i.rstrip().split(','))


##Make symlinks for al Chesapeake and controls. I'll just leave the lake controls in as well. 
forward=[]
reverse=[]
for i in seqinfo:
    if 'Chesapeake' in i[1] or 'Control' in i[1]: 
        parts=i[4].split('-')        
        fname=parts[1]+'~'+parts[0]
        for_name=fname+'_1.fastq'
        forward.append(for_name)
        rev_name=fname+'_2.fastq'
        reverse.append(rev_name)
        os.symlink(seqpre+for_name, datadir+'/data/'+for_name)
        os.symlink(seqpre+rev_name, datadir+'/data/'+rev_name)
        

with open(datadir+'/forward.txt', 'w') as f:
    for i in forward:
        f.write(i+'\n')

with open(datadir+'/reverse.txt', 'w') as f:
    for i in reverse:
        f.write(i+'\n')
