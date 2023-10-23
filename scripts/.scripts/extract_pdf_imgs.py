#!/usr/bin/env python3

import os
import argparse
import fitz
import hashlib


def extract_images_from_pdf(path):
    doc = fitz.open(path)
    images = []
    for i in range(len(doc)):
        for img in doc.get_page_images(i):
            xref = img[0]
            pix = fitz.Pixmap(doc, xref)
            images.append(pix)
    return images


def save_images(images, base, output_dir):
    seen = set()  # keep track of images we've already saved
    for i, pix in enumerate(images):
        # we'll use the MD5 hash of the image data to identify duplicate images
        data = pix.samples
        hash_md5 = hashlib.md5(data).hexdigest()
        if hash_md5 in seen:
            continue
        seen.add(hash_md5)
        filename = f"{base}_img{str(i)}.png"
        filename = os.path.join(output_dir, filename)  # add output directory to the filename
        if pix.n < 5:       # this is GRAY or RGB
            pix.pil_save(filename)
        else:               # CMYK: convert to RGB first
            pix1 = fitz.Pixmap(fitz.csRGB, pix)
            pix1.pil_save(filename)
            pix1 = None


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Extract images from a PDF.')
    parser.add_argument('pdf_file', help='The PDF file to extract images from.')
    parser.add_argument('--output_dir', default='.', help='The output directory to save the images. Defaults to the current directory.')
    args = parser.parse_args()

    base = os.path.splitext(os.path.basename(args.pdf_file))[0]  # remove .pdf from filename
    images = extract_images_from_pdf(args.pdf_file)
    save_images(images, base, args.output_dir)
