import PyPDF2
import argparse


def extract_titles(pdf_path):
    pdf_file_obj = open(pdf_path, 'rb')
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
    # Copy to system tray
    parser.add_argument('-x',
                        '--system_tray',
                        action='store_true',
                        help='Save to system tray.')
    # Export to txt
    parser.add_argument('-o', '--output', help='Path to output text file.')

    args = parser.parse_args()

    titles = extract_titles(args.pdf_path)

    if args.system_tray:
        # This is just a placeholder. You'll need to implement this with a library like pystray.
        print('Saving titles to system tray is not implemented.')

    if args.output:
        with open(args.output, 'w') as f:
            for title in titles:
                f.write(title + '\n')


if __name__ == '__main__':
    main()
