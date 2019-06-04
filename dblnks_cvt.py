#!/usr/bin/env python3
#####################################
import sys
input_lnk  = sys.argv[1]
lnk = input_lnk[0:-5]
https = lnk[0:8]
file_name = lnk[19:]
insert = 'dl.dropboxusercontent'
output = https+insert+file_name
print(output)

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################