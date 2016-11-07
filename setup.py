""" setup.py """
from setuptools import setup, find_packages
from version import get_version


def main():
    """Install information-package-tools Python libraries"""
    setup(
        name='kdk_mets_catalog',
        packages=find_packages(exclude=['tests', 'tests.*']),
        version=get_version())

if __name__ == '__main__':
    main()
