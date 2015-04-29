#! /usr/bin/env python3

"""
Convert the YAML in the file at the path in `sys.argv[1]` to JSON, preserving
order. Used in vim/ftplugin/json.vim
"""

import collections
import json
import sys
import yaml
import sys

yaml_file_path = sys.argv[1]

with open(yaml_file_path) as yaml_file:
	yaml_str = yaml_file.read()

def dict_representer(dumper, data):
	return dumper.represent_dict(data.iteritems())

def dict_constructor(loader, node):
	return collections.OrderedDict(loader.construct_pairs(node))

yaml.add_representer(collections.OrderedDict, dict_representer)
yaml.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, dict_constructor)

formatted_json = json.dumps(yaml.load(yaml_str), indent="\t")
with open(yaml_file_path, "w") as yaml_file:
	yaml_file.write(formatted_json)
