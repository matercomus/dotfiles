import PyPDF2
import argparse
import subprocess


def is_binary(file_path):
    """Check if a file is binary or text."""
    with open(file_path, 'rb') as f:
        for block in f:
            if b'\0' in block:
                return True
    return False


def extract_titles(pdf_path, mode):
    pdf_file_obj = open(pdf_path, mode)
    pdf_reader = PyPDF2.PdfFileReader(pdf_file_obj)
    titles = []

    for page_num in range(pdf_reader.numPages):
        page_obj = pdf_reader.getPage(page_num)
        text = page_obj.extractText()
        title = text.split('\n')[0]  # assumes title is first line of each page
        titles.append(title)

    pdf_file_obj.close()
    return titles


def main():
    parser = argparse.ArgumentParser(description='Extract titles from a PDF.')
    parser.add_argument('pdf_path', help='Path to the PDF file.')
    parser.add_argument('-x', '--system_tray', action='store_true',
                        help='Copy to clipboard.')
    parser.add_argument('-o', '--output', help='Path to output text file.')

    args = parser.parse_args()

    mode = 'rb' if is_binary(args.pdf_path) else 'r'
    titles = extract_titles(args.pdf_path, mode)

    if args.system_tray:
        # Copy titles to clipboard using xclip
        titles_str = '\n'.join(titles)
        subprocess.run('echo -n "{}" | xclip -selection clipboard'.format(titles_str),
                       shell=True)

    if args.output:
        with open(args.output, 'w') as f:
            for title in titles:
                f.write(title + '\n')


if __name__ == '__main__':
    main()
