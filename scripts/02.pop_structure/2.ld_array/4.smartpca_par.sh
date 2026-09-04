for i in 0.8 0.6 0.2 0.1
do
	cat <<EOF > "${i}/smartpca.par"
genotypename: scripts/01.filtering/2.hard_filtered/05.f_missing0.10/output/${i}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${i}_ld_pruned.ped
snpname: scripts/01.filtering/2.hard_filtered/05.f_missing0.10/output/${i}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${i}_ld_pruned.map
indivname: scripts/01.filtering/2.hard_filtered/05.f_missing0.10/output/${i}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${i}_ld_pruned.ped
evecoutname: ${i}/output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${i}_ld_pruned.evec
evaloutname: ${i}/output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${i}_ld_pruned.eval
numoutevec: 50
numoutlieriter: 0
altnormstyle: NO
grmoutname: ${i}/output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${i}_ld_pruned.grm
familynames: NO
EOF
done
