#!/usr/bin/env python3
#####################################
import argparse
import os

def main():
    parser = argparse.ArgumentParser(description = "format bigWig file PATH and configuration for UCSC GiGB local tracks loading")
    parser.add_argument('file')
    parser.add_argument("-c", "--color", help="Color for track", default='32,32,32')
    parser.add_argument("-n", "--name", help="Title showed for track")
    parser.add_argument("-t", "--type", help="Track type", default='bigWig')
    parser.add_argument("-h", "--height", help="Track height in pixels", default='40')
    parser.add_argument("-s", "--smooth", help="Track edge smoothing in pixels", default='4')
    parser.add_argument("-v", "--visibility", choices=['0', '1', '2', '3', '4'],help="0 - hide, 1 - dense, 2 - full, 3 - pack, and 4 - squish", default='2' )
    args = parser.parse_args()
    
    if not args.name:
        args.name = args.file.rsplit('/',1)[-1].rsplit('.',1)[0]
        
    in_path=os.path.abspath(args.file)[22:]

    prefix = 'bigDataUrl=http://127.0.0.1:1234/folders/sf_Documents/'

    out_str = "track type=%s visibility=%s smoothingWindow=%s maxHeightPixels=%s name=%s color=%s %s%s" %(args.type, args.visibility, args.smooth, args.height, args.name, args.color, prefix, in_path)

    print(out_str)
    
main()