"""Package information.
This module contains information (such as version number) of the package.
"""

from distutils.version import LooseVersion

__version__ = "0.1.0"
__version_info__ = tuple(LooseVersion(__version__).version)
