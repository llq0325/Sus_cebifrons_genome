mysql -u root < mysql.setting.template
# orthomclFilterFasta compliantFasta/ 10 20
# makeblastdb -in goodProteins.fasta -dbtype prot
# blastp -db goodProteins.fasta -query goodProteins.fasta -out all-all.blastp.out -evalue 1e-5 -outfmt 6 -num_threads 24
orthomclInstallSchema orthomcl.config.template
orthomclBlastParser all.blastp.out.noBCL.5 compliantFasta > similarSequences.txt
echo 0
perl -p -i -e 's/0\t0/1\t-181/' similarSequences.txt
echo 1
orthomclLoadBlast orthomcl.config.template similarSequences.txt
echo 2
echo `date`
orthomclPairs orthomcl.config.template orthomcl_pairs.log cleanup=no
echo 3
echo `date`
orthomclDumpPairsFiles orthomcl.config.template
echo 4
mcl mclInput --abc -I 1.5 -o mclOutput
echo 5
orthomclMclToGroups cluster 1 < mclOutput > groups.txt
echo `date`
