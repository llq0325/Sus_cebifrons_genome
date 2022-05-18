python scripts/cafetutorial_mcl2rawcafe.py -i mclOutput -o unfiltered_cafe_input.txt -sp "bos giraffe milu reindeer LS camel homo pig sheep ST dog horse pronghorn whale"
python scripts/cafetutorial_clade_and_size_filter.py -i unfiltered_cafe_input.txt -o filtered_cafe_input.txt -s

cafe cafetutorial_run1.sh
cafe cafetutorial_run2.sh

python scripts/cafetutorial_report_analysis.py -i reports/report_run1.cafe -o report_1
python scripts/cafetutorial_report_analysis.py -i reports/report_run2.cafe -o report_2
