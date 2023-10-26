#!/usr/bin/env python3

import os
import argparse
import fitz
import hashlib
import concurrent.futures

def extract_images_from_page(page):
    images = []
    for img in page.get_images(full=True):
        xref = img[0]
        pix = fitz.Pixmap(page.parent, xref)  # use page.parent to access the doc
        images.append(pix)
    return images

def save_image(i, pix, base, output_dir, seen):
    # we'll use the MD5 hash of the image data to identify duplicate images
    data = pix.samples
    hash_md5 = hashlib.md5(data).hexdigest()
    if hash_md5 in seen:
        return
    seen.add(hash_md5)
    filename = f"{base}_img{str(i)}.png"
    filename = os.path.join(output_dir, filename)  # add output directory to the filename
    if pix.n < 5:       # this is GRAY or RGB
        pix.pil_save(filename)
    else:               # CMYK: convert to RGB first
        pix1 = fitz.Pixmap(fitz.csRGB, pix)
        pix1.pil_save(filename)

def validate_input(pdf_file, output_dir):
    # Check if pdf_file exists and is a PDF
    if not os.path.isfile(pdf_file) or not pdf_file.lower().endswith('.pdf'):
        print(f"Error: {pdf_file} does not exist or is not a PDF.")
        exit(1)

    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

def extract_images(pdf_file):
    doc = fitz.open(pdf_file)
    with concurrent.futures.ThreadPoolExecutor() as executor:
        futures = [executor.submit(extract_images_from_page, page) for page in doc]
        images = []
        for future in concurrent.futures.as_completed(futures):
            images.extend(future.result())
    return images

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Extract images from a PDF.')
    parser.add_argument('pdf_file', help='The PDF file to extract images from.')
    parser.add_argument('--output_dir', default='.', help='The output directory to save the images. Defaults to the current directory.')
    args = parser.parse_args()

    validate_input(args.pdf_file, args.output_dir)

    base = os.path.splitext(os.path.basename(args.pdf_file))[0]  # remove .pdf from filename

    images = extract_images(args.pdf_file)

    seen = set()  # keep track of images we've already saved
    for i, pix in enumerate(images):
        save_image(i, pix, base, args.output_dir, seen)
