# boolpack

Efficient **Cython-based** encoder/decoder for Python lists of booleans into a compact, versioned binary format. Supports **128-bit, 256-bit, and 1024-bit containers** with minimal padding and a version byte for forward compatibility.

## Features

* Pack/unpack lists of bools efficiently
* Versioned format: 128, 256, 1024 bits
* Stores actual list length → ignores padding
* LSB-first bit order, little-endian
* Pure C-speed loops via Cython
* Easy to use in Python projects

## Installation

```bash
git clone <repo_url>
cd boolpack_uv
pip install cython setuptools
python -m pip install .
```

or if you prefer editable mode:

```bash
pip install -e .
```

## Usage

```python
from boolpack import bools_to_bytes, bytes_to_bools

lst = [True, False, True, True]

encoded = bools_to_bytes(lst)
decoded = bytes_to_bools(encoded)

assert decoded
```

