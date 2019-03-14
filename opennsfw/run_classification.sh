#! /bin/bash
export pcapfolder='/work/pcap'
export currentname=$(date -u +"fullpkt.%Y%m%d$(expr $(date -u +"%H") - 1).gz")

# Run export and classification
if [ -e $pcapfolder/$currentname ]
then
    cd /work/images
    echo "classification of $currentname started at $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
    zcat $pcapfolder/$currentname | bro -r - /work/bro/extract-all.bro && 
        python /work/opennsfw/classify_nsfw.py \
            --model_def /work/opennsfw/nsfw_model/deploy.prototxt \
            --pretrained_model /work/opennsfw/nsfw_model/resnet_50_1by2_nsfw.caffemodel \
            /work/images
    echo "classification of $currentname ended at $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
fi