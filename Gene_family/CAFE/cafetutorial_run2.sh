#!/public/home/yangjie/software/CAFE/release/cafe
load -i large_filtered_cafe_input.txt -t 8 -l reports/log_run2.txt
tree  (((dog:77.700885,horse:77.700885):6.020975,((pig:3.491897,SCEB:3.491897):65.180694,cattle:68.672591):15.049269):10.278140,(human:79.292504,mouse:79.292504):14.707496);
lambda -l 0.00652936628260 0.01254376524169 0.00882150180239 -t (((1,1)1,((2,2)2,2)2)1,(3,3)1)
report reports/report_run2
