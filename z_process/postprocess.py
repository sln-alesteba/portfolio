# script to postprocess web creation:
# clean comments and generte:

from bs4 import BeautifulSoup as bs
import lxml.html as lh

def main(root_dir):

    # iterate directory and transforms for each html file _>
    # cant I do it directly form ruby ¿?

    import os
    fi = []
    for root, dirs, files in os.walk("/"):
        for file in files:
            if file.endswith(('.html')):
                fi.append(os.path.join(root, file))
                #print(os.path.join(root, file))

    # postprocess them :
    for f in fi:
        postprocess_file(f)


def postprocess_file(file):

    root = lh.tostring(file) #convert the generated HTML to a string
    soup = bs(root)                #make BeautifulSoup
    prettyHTML = soup.prettify()   #prettify the html

    return prettyHTML

if __name__ == "__main__":
    main()

# https://pypi.org/project/py-html-checker/
# https://docs.python.org/3/library/html.parser.html
# parse html -> 

