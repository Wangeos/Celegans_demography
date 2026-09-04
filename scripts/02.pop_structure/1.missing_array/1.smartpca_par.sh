for i in $(seq 0.05 0.05 0.95)
do
	cat <<EOF > "${i}/smartpca.par"
genotypename: scripts/01.filtering/2.hard_filtered/04.missing_array/output/${i}/WI.20231213.hard-filter.isotype.rename_chrs.missing_${i}.ped
snpname: scripts/01.filtering/2.hard_filtered/04.missing_array/output/${i}/WI.20231213.hard-filter.isotype.rename_chrs.missing_${i}.map
indivname: scripts/01.filtering/2.hard_filtered/04.missing_array/output/${i}/WI.20231213.hard-filter.isotype.rename_chrs.missing_${i}.ped
evecoutname: output/WI.20231213.hard-filter.isotype.rename_chrs.missing_${i}.evec
evaloutname: output/WI.20231213.hard-filter.isotype.rename_chrs.missing_${i}.eval
numoutevec: 50
numoutlieriter: 0
altnormstyle: NO
grmoutname: output/WI.20231213.hard-filter.isotype.rename_chrs.missing_${i}.grm
familynames: NO
EOF
done
