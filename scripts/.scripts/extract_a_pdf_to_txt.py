#!/usr/bin/env python3

import sys
import PyPDF2


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
        with open(output_file, 'w') as f:
            for i in range(start_page-1, end_page):
                page = reader.pages[i]
                text = page.extract_text()
                text = connect_lines(text)
                f.write(text + '\n\n')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python extract_pages.py <pdf_file> [start_page] [end_page] [output_file]")
    else:
        pdf_file = sys.argv[1]
        start_page = int(sys.argv[2]) if len(sys.argv) > 2 else None
        end_page = int(sys.argv[3]) if len(sys.argv) > 3 else None
        output_file = sys.argv[4] if len(sys.argv) > 4 else 'output.txt'
        extract_pages(pdf_file, start_page, end_page, output_file)
