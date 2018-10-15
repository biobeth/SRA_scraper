usage(){
    echo "makesradb.sh makes a human-readable tab-delimited text file of SRA data. 
Usage sra2plot [opts] [input]
    
    Options:
                -h      Display this help

                Turn off defaults
                -d      Turn off download. Default: download all required metadata to the working directory (warning: large files)"
}

DOWNLOAD=true

while getopts :s:r:n:thdmpx opt; do
    case "${opt}" in
        h) usage;exit;;
        d) DOWNLOAD=false;;
        \?) echo "Unknown option: -${OPTARG}" >&2; exit 1;;
        :) echo "Missing option argument for -${OPTARG}" >&2; exit 1;;
        *) echo "Unimplemented option: -${OPTARG}" >&2; exit;;
    esac
done
shift $((${OPTIND}-1))

if $DOWNLOAD;then
        curl "ftp://ftp-trace.ncbi.nlm.nih.gov/sra/reports/Metadata/SRA_Accessions.tab" > SRA_Accessions.tab
	curl "ftp://ftp.ncbi.nlm.nih.gov/biosample/biosample_set.xml.gz" > biosample_set.xml.gz
	curl "ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt" > assembly_summary.txt
fi

#get accessions linked with read data

grep -E "      live    .*      RUN     " SRA_Accessions  > SRA_runs.txt 
#get SRA and biosample accessions
cut -f1,18 SRA_runs.txt | grep -v - > SRA_with_biosample.txt

gzip -d biosample_set.xml.gz

#!/usr/bin/perl 

#use strict;
#open(SAMPLE,"< biosample_set.xml");
#
#while(<SAMPLE>){
#    if($_ =~/^\<\/BioSample\>/){
#        print $_;
#    }
#    else{
#        my $a=$_;
#        chomp($a);
#        print $a;
#    }
#}
#(END)

#^could make this a one-liner
./srascrape.pl > biosample_format.txt

#get tax_ids associated w/ sample
cat biosample_format.txt | perl -lane 'if($_ =~/accession=\"(\S+)\".*taxonomy_id=\"(\S+)\"/){print $1,"\t",$2;}' > biosample_taxid.txt

#which biosample tax IDs are from bacteria?
for i in `cut -f2 biosample_taxid.txt | sort | uniq`; do if grep -q $i bacteria_assembly_summary.txt; then echo $i; fi; done > biosample_bacteria_taxid.txt

#grab all biosamples and taxids that are from bacteria
while read line; do grep -E "  $line$" biosample_taxid.txt >> biosample_bacteria_taxid_FINAL.txt; done < biosample_bacteria_taxid.txt

#condensed summary info
grep -Ei "Complete Genome" bacteria_assembly_summary.txt > bacteria_assembly_summary.txt2

cut -f1,6,8,12 bacteria_assembly_summary.txt2 > acc_taxid_name_assemblylevel.txt


./sra_db.pl > SRA_bacteria.txt

