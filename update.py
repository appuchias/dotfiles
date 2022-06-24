#!/usr/bin/env python3

import os
import pathlib
from time import sleep

ROOT_DIR = pathlib.Path("/home/appu")
BK_DIR = pathlib.Path("/home/appu/.dotfiles/files")
TAR_BK_AMOUNT_MINUS_ONE = 4 # Real amount of backups will be TAR_BK_AMOUNT_MINUS_ONE + 1


def main(root, backup):
    backed_files = [
        ".shellrc",
        ".shell_aliases",
        ".bashrc",
        ".bash_profile",
        ".dir_colors",
        ".config/starship.toml",
        ".vimrc",
    ]

    backed_folders = [
        ".config/kitty",
        ".config/fish",
        ".config/htop",
        ".config/alacritty",
        ".config/rofi",
        ".config/awesome",
    ]

    print(" --- CYCLE TGZs --- ")
    sleep(0.2)
    os.system(f"rm {BK_DIR.parent / 'TGZ' / f'files{TAR_BK_AMOUNT_MINUS_ONE}.tgz'}")
    for n in range(TAR_BK_AMOUNT_MINUS_ONE, 0 - 1, -1):
        bk_path = BK_DIR.parent / f"files{n}.tgz"
        if os.path.exists(bk_path):
            os.system(f"mv -v {bk_path} {BK_DIR.parent / 'TGZ' / f'files{n+1}.tgz'}")

    print("\n\n\n --- CP FILES/FOLDERS --- ")
    sleep(0.2)
    # Clean files/ before copying
    os.system(f"rm -r {BK_DIR}/*")

    # Files
    for file in backed_files:
        os.system(f"cp -v {ROOT_DIR / file} {BK_DIR / file}")

    # Folders
    for folder in backed_folders:
        os.system(f"cp -vr {ROOT_DIR / folder} {BK_DIR / '.config'}")

    print("\n\n\n --- TAR --- ")
    sleep(0.2)
    os.system(f"tar czvf /home/appu/.dotfiles/TGZ/files0.tgz /home/appu/.dotfiles/files/")


if __name__ == "__main__":
    main(ROOT_DIR, BK_DIR)
    print("\nDONE")
