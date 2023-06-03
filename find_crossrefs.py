import pandoc as pa
from pandoc.types import *
import os, yaml
import quarto, subprocess, json

prefixes = {'thm-', 'lem-', 'cor-', 'prp-', 'cnj-', 'exm-', 'def-', 'exr-'}

cmd = [quarto.quarto.find_quarto(), "inspect"]
project = json.loads(subprocess.check_output(cmd))

found = { p: [] for p in prefixes }
for src in project["files"]["input"]:
    doc = pa.read(file=src)

    for el in pa.iter(doc):
        if isinstance(el, Div):
            attr, block = el
            ident, classes, keyval = attr
            prefix = ident[:4]
            if prefix in prefixes:
                newguy = dict(keyval)
                newguy['link'] = '@' + ident
                found[prefix].append(newguy)

if not os.path.exists("_crossrefs"):
    os.makedirs("_crossrefs")

for prefix in prefixes:
    if len(found[prefix]) > 0:
        fname = os.path.join("_crossrefs", prefix[:3] + '.yml')
        with open(fname, 'w') as file:
            yaml.safe_dump(found[prefix], file)