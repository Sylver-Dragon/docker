#!/usr/bin/env python
"""
Copyright 2016 Yahoo Inc.
Licensed under the terms of the 2 clause BSD license. 
Please see LICENSE file in the project root for terms.
"""

import numpy as np
import os
import sys
import argparse
import glob
import time
from PIL import Image
from StringIO import StringIO
from shutil import copy

"""
Set log level:
    0 - debug
    1 - info (still a LOT of outputs)
    2 - warnings
    3 - errors 
"""
os.environ["GLOG_minloglevel"] = "2"

import caffe

class _print_colors:
    RED = '\033[91m'
    YELLOW = '\033[93m'
    GREEN = '\033[2;32m'
    ENDCOLOR = '\033[0m'

class _thresholds:
    LOW = 0.25
    MEDIUM = 0.6
    HIGH = 0.85

def resize_image(data, sz=(256, 256)):
    """
    Resize image. Please use this resize logic for best results instead of the 
    caffe, since it was used to generate training dataset 
    :param str data:
        The image data
    :param sz tuple:
        The resized image dimensions
    :returns bytearray:
        A byte array with the resized image
    """
    img_data = str(data)
    im = Image.open(StringIO(img_data))
    if im.mode != "RGB":
        im = im.convert('RGB')
    imr = im.resize(sz, resample=Image.BILINEAR)
    fh_im = StringIO()
    imr.save(fh_im, format='JPEG')
    fh_im.seek(0)
    return bytearray(fh_im.read())

def caffe_preprocess_and_compute(pimg, caffe_transformer=None, caffe_net=None,
    output_layers=None):
    """
    Run a Caffe network on an input image after preprocessing it to prepare
    it for Caffe.
    :param PIL.Image pimg:
        PIL image to be input into Caffe.
    :param caffe.Net caffe_net:
        A Caffe network with which to process pimg afrer preprocessing.
    :param list output_layers:
        A list of the names of the layers from caffe_net whose outputs are to
        to be returned.  If this is None, the default outputs for the network
        are returned.
    :return:
        Returns the requested outputs from the Caffe net.
    """
    if caffe_net is not None:

        # Grab the default output names if none were requested specifically.
        if output_layers is None:
            output_layers = caffe_net.outputs

        img_data_rs = resize_image(pimg, sz=(256, 256))
        image = caffe.io.load_image(StringIO(img_data_rs))

        H, W, _ = image.shape
        _, _, h, w = caffe_net.blobs['data'].data.shape
        h_off = max((H - h) / 2, 0)
        w_off = max((W - w) / 2, 0)
        crop = image[h_off:h_off + h, w_off:w_off + w, :]
        transformed_image = caffe_transformer.preprocess('data', crop)
        transformed_image.shape = (1,) + transformed_image.shape

        input_name = caffe_net.inputs[0]
        all_outputs = caffe_net.forward_all(blobs=output_layers,
                    **{input_name: transformed_image})

        outputs = all_outputs[output_layers[0]][0].astype(float)
        return outputs
    else:
        return []

def classify_images(path, caffe_transformer, caffe_net):
    high_folder = os.path.join('/work/nsfw/high')
    medium_folder = os.path.join('/work/nsfw/medium')

    for input_file in os.listdir(path):
        full_file_name = os.path.join(path, input_file)    
        if os.path.isdir(full_file_name) and not os.path.islink(full_file_name):
            classify_images(full_file_name, caffe_transformer, caffe_net)
            continue

        image_data = open(full_file_name).read()

        # Classify
        try:
            scores = caffe_preprocess_and_compute(
                image_data, 
                caffe_transformer=caffe_transformer, 
                caffe_net=caffe_net, output_layers=['prob']
            )
        except Exception as ex:
            #print 'Unable to score file: ', full_file_name
            #print 'Error: ', ex.message
            continue

        # Scores is the array containing SFW / NSFW image probabilities
        # scores[1] indicates the NSFW probability
        file_out = input_file.replace('/','_')
        if file_out.startswith('.'):
            file_out = file_out[1:]
        if file_out.startswith('_'):
            file_out = file_out[1:]
        nsfw_score = scores[1]
        if nsfw_score >= _thresholds.HIGH:
            print_color = _print_colors.RED
            copy(full_file_name, os.path.join(high_folder, file_out))
            os.chmod(os.path.join(high_folder, file_out), 0666)
            print print_color, full_file_name, ' NSFW Score: ', nsfw_score, _print_colors.ENDCOLOR
        elif nsfw_score >= 0.5 and nsfw_score < 0.75:
            print_color = _print_colors.YELLOW
            copy(full_file_name, os.path.join(medium_folder, file_out))
            os.chmod(os.path.join(medium_folder, file_out), 0666)
            print print_color, full_file_name, ' NSFW Score: ', nsfw_score, _print_colors.ENDCOLOR
        else:
            print_color = _print_colors.GREEN

def main(argv):
    pycaffe_dir = os.path.dirname(__file__)

    parser = argparse.ArgumentParser()
    # Required arguments: input file.
    parser.add_argument(
        "input_folder",
        help="Path to the input folder of image files"
    )

    # Optional arguments.
    parser.add_argument(
        "--model_def",
        help="Model definition file."
    )
    parser.add_argument(
        "--pretrained_model",
        help="Trained model weights file."
    )

    args = parser.parse_args()
    
    classified_images = 0
    #not_classified_images = 0

    # Pre-load caffe model.
    nsfw_net = caffe.Net(args.model_def,  # pylint: disable=invalid-name
        args.pretrained_model, caffe.TEST)

    # Load transformer
    # Note that the parameters are hard-coded for best results
    caffe_transformer = caffe.io.Transformer({'data': nsfw_net.blobs['data'].data.shape})
    caffe_transformer.set_transpose('data', (2, 0, 1))  # move image channels to outermost
    caffe_transformer.set_mean('data', np.array([104, 117, 123]))  # subtract the dataset-mean value in each channel
    caffe_transformer.set_raw_scale('data', 255)  # rescale from [0, 1] to [0, 255]
    caffe_transformer.set_channel_swap('data', (2, 1, 0))  # swap channels from RGB to BGR

    classify_images(args.input_folder, caffe_transformer, nsfw_net)

    #print 'images classifed: ', classified_images
    #print 'images which could not be classified: ', not_classified_images

if __name__ == '__main__':
    main(sys.argv)