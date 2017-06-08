// Written in the D programming language.

/**
 * 
 * Conversion between JSON and TOML.
 *
 * License: $(HTTP https://github.com/Kripth/toml/blob/master/LICENSE, MIT)
 * Authors: Kripth
 * References: $(LINK https://github.com/toml-lang/toml/blob/master/README.md)
 * Source: $(HTTP https://github.com/Kripth/toml, Kripth/_toml.d)
 * 
 */
module toml.json;

import std.json : JSONValue, JSON_TYPE;

import toml.toml : TOMLDocument, TOMLValue, TOML_TYPE;

/**
 * Converts a TOMLValue to a JSONValue.
 */
JSONValue toJSON(TOMLValue toml) {
	final switch(toml.type) with(TOML_TYPE) {
		case BOOL: return JSONValue(toml.boolean);
		case STRING: return JSONValue(toml.str);
		case INTEGER: return JSONValue(toml.integer);
		case FLOAT: return JSONValue(toml.floating);
		case OFFSET_DATETIME: return JSONValue(toml.offsetDatetime.toISOExtString());
		case LOCAL_DATETIME: return JSONValue(toml.localDatetime.toISOExtString());
		case LOCAL_DATE: return JSONValue(toml.localDate.toISOExtString());
		case LOCAL_TIME: return JSONValue(toml.localTime.toISOExtString());
		case ARRAY:
			JSONValue[] ret;
			foreach(value ; toml.array) {
				ret ~= toJSON(value);
			}
			return JSONValue(ret);
		case TABLE:
			JSONValue[string] ret;
			foreach(key, value; toml.table) {
				ret[key] = toJSON(value);
			}
			return JSONValue(ret);
	}
}

/// ditto
JSONValue toJSON(TOMLDocument doc) {
	return toJSON(TOMLValue(doc.table));
}

///
unittest {

	import std.datetime;

	assert(toJSON(TOMLValue(true)).type == JSON_TYPE.TRUE);
	assert(toJSON(TOMLValue("string")).str == "string");
	assert(toJSON(TOMLValue(42)) == JSONValue(42));
	assert(toJSON(TOMLValue(.1)) == JSONValue(.1));
	assert(toJSON(TOMLValue(SysTime.fromISOExtString("1979-05-27T07:32:00Z"))).str == "1979-05-27T07:32:00Z");
	assert(toJSON(TOMLValue(DateTime.fromISOExtString("1979-05-27T07:32:00"))).str == "1979-05-27T07:32:00");
	assert(toJSON(TOMLValue(Date.fromISOExtString("1979-05-27"))).str == "1979-05-27");
	assert(toJSON(TOMLValue(TimeOfDay.fromISOExtString("07:32:00"))).str == "07:32:00");
	assert(toJSON(TOMLValue([1, 2, 3])) == JSONValue([1, 2, 3]));
	assert(toJSON(TOMLDocument(["a": TOMLValue(0), "b": TOMLValue(1)])) == JSONValue(["a": 0, "b": 1]));
}

/**
 * Convert a JSONValue to a TOMLValue.
 */
TOMLValue toTOML(JSONValue json) {
	final switch(json.type) with(JSON_TYPE) {
		case NULL: return TOMLValue("null");
		case TRUE: return TOMLValue(true);
		case FALSE: return TOMLValue(false);
		case STRING: return TOMLValue(json.str);
		case INTEGER: return TOMLValue(json.integer);
		case UINTEGER: return TOMLValue(cast(long)json.uinteger);
		case FLOAT: return TOMLValue(json.floating);
		case ARRAY:
			TOMLValue[] ret;
			foreach(value ; json.array) {
				ret ~= toTOML(value);
			}
			return TOMLValue(ret);
		case OBJECT:
			TOMLValue[string] ret;
			foreach(key, value; json.object) {
				ret[key] = toTOML(value);
			}
			return TOMLValue(ret);
	}
}

///
unittest {

	assert(toTOML(JSONValue.init) == "null");
	assert(toTOML(JSONValue(true)).type == TOML_TYPE.BOOL);
	assert(toTOML(JSONValue(false)) == false);
	assert(toTOML(JSONValue("test")) == "test");
	assert(toTOML(JSONValue(42)) == 42);
	assert(toTOML(JSONValue(ulong.max)) == -1);
	assert(toTOML(JSONValue(.1)) == .1);
	assert(toTOML(JSONValue([1, 2, 3])) == [1, 2, 3]);
	assert(toTOML(JSONValue(["a": 1, "b": 2])) == ["a": 1, "b": 2]);

}
