""" setup.py """
from setuptools import setup, find_packages
from version import get_version


def main():
    """Install dpres-xml-schemas Python libraries"""
    setup(
        name='dpres-xml-schemas',
        packages=find_packages(exclude=['tests', 'tests.*']),
        version=get_version())

if __name__ == '__main__':
    main()
