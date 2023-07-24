#integrar git con python; hacer un commit cada vez que se copie la web;

# FUNCIONA EL repositorio desde python:
# https://blog.balasundar.com/automate-git-operations-using-python


import shutil
import os
import random
import string

from shutil import ignore_patterns

directory_path = os.getcwd()
parent_path = os.path.abspath(os.path.join(directory_path, os.pardir))

print("My current directory is : " + directory_path)
print("Parent directory is : " + parent_path)

# folder_name = os.path.basename(directory_path)
# print("folder_name: " + directory_path)

src_path = os.path.join(directory_path, "_site")
dst_path = os.path.join(parent_path ,"s.ln_blog_prod")

# remove site fodler except .git;

# ignore=shutil.ignore_patterns('.git*')

# def ignore_full_path_common(dir, files):
#     if dir == '/.git':
#         return ['Common']
#     return []

# necesito recorrerlo de otra forma y analizar subdirecorio (que será mas facil.)

delete_paths = []

print (dst_path)

for entry in os.listdir(dst_path):

    if os.path.isdir(entry):

        print(os.path.basename(entry))

        if os.path.basename(entry) != '.git':

            rm_tree = os.path.join(dst_path, entry)

            print(rm_tree)

            shutil.rmtree(rm_tree)
            # no puedo eliminiarlo porque lo estoy leyendo a la vez; -> si puedoo
        else:
            print('GIT')

    if os.path.isfile(entry):

        rm_tree = os.path.join(dst_path, entry)

        os.remove(rm_tree)

#     if os.path.exists(dst_path):
#     shutil.rmtree(dst_path)

# if os.path.exists(dst_path):
#     shutil.rmtree(dst_path)

#mantener .git fuera de la estructura de copia: (y poder no eliminarlo cuando borre los archivos)

#https://pyquestions.com/how-do-i-copy-an-entire-directory-of-files-into-an-existing-directory-using-python
shutil.copytree(src_path, dst_path, dirs_exist_ok=True) #esto uutlimo funciona en python 3.8; #dirs_exist_ok=True

print('Copied')