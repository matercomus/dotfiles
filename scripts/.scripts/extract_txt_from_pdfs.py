#!/usr/bin/env python3

import glob
import os
import sys

import PyPDF2

char_limit = 20000


def connect_lines(text):
    lines = text.split('\n')
    new_text = ''
    for line in lines:
        if line.endswith('-'):
            new_text += line[:-1]
        else:
            new_text += line + ' '
    return new_text


def extract_pages(pdf_file, start_page=None, end_page=None, output_file='output.txt'):
    with open(pdf_file, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        if start_page is None:
            start_page = 1
        if end_page is None:
            end_page = len(reader.pages)
        chapter_text = ""
        for i in range(start_page-1, end_page):
            page = reader.pages[i]
            text = page.extract_text()
            chapter_text += text
        chapter_text = connect_lines(chapter_text)
        with open(output_file, 'w') as f:
            for i in range(0, len(chapter_text), char_limit):
                f.write(chapter_text[i:i+char_limit] + '\n\n')


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: python extract_pages.py <pdf_directory> <output_directory>")
    else:
        pdf_dir = sys.argv[1]
        output_dir = sys.argv[2]

        # Get all PDF files in the directory
        pdf_files = glob.glob(os.path.join(pdf_dir, '*.pdf'))

        # Process each PDF file
        for pdf_file in pdf_files:
            # Construct the output file name based on the PDF file name
            base_name = os.path.basename(pdf_file)
            base_name = os.path.splitext(base_name)[0]
            output_file = os.path.join(output_dir, base_name + '.txt')

            # Extract pages from the PDF file
            extract_pages(pdf_file, None, None, output_file)
