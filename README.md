D implementation of [Tom's Obvious, Minimal Language](https://github.com/toml-lang/toml/blob/master/README.md) version [0.4.0](https://github.com/toml-lang/toml/blob/master/versions/en/toml-v0.4.0.md)


[![Build Status](https://travis-ci.org/Kripth/toml.svg?branch=master)](https://travis-ci.org/Kripth/toml) 
[![Code Coverage](https://codecov.io/gh/Kripth/toml/branch/master/graph/badge.svg)](https://codecov.io/gh/Kripth/toml)
[![DUB Package](https://img.shields.io/dub/v/toml.svg)](https://code.dlang.org/packages/toml)
[![DUB Downloads](https://img.shields.io/dub/dt/toml.svg)](https://code.dlang.org/packages/toml) 

# Usage

**dub.json**: `"toml": "~>0.4.0-rc.2"`
**dub.sdl**: `dependency "toml" version="~>0.4.0-rc.2"`

```d
import toml;

TOMLDocument doc;

doc = parseTOML("example = 1");
assert(doc["example"].integer == 1);

doc = parseTOML(`
	bool = true
	integer = 42
	floating = 1e2
	string = "string"
`)
assert(doc["bool"] == true);
assert(doc["integer"] == 42);
assert(doc["floating"] == 1e2);
assert(doc["string"] == "string");

// from a file
import std.file : read;
doc = parseTOML(cast(string)read("/path/to/file.toml"));
```

# Conversion

### JSON

**dub.json**: `"toml:json": "~>0.4.0-rc.2"`
**dub.sdl**: `dependency "toml:json" version="~>0.4.0-rc.2"`

```d
import std.json;

import toml;
import toml.json;

auto json = JSONValue([1, 2, 3]);
assert(toTOML(json).type == TOML_TYPE.ARRAY);
assert(toTOML(json) == [1, 2, 3]);

auto toml = parseTOML(`key = "value"`);
assert(toJSON(toml).type == JSON_TYPE.OBJECT);
assert(toJSON(toml) == JSONValue(["key": "value"]));
```

# Missing features

- Nested array of tables
