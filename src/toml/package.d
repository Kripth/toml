// Written in the D programming language.

/**
 * 
 * Tom's Obvious, Minimal Language (v0.4.0).
 *
 * License: $(HTTP https://github.com/Kripth/toml/blob/master/LICENSE, MIT)
 * Authors: Kripth
 * References: $(LINK https://github.com/toml-lang/toml/blob/master/README.md)
 * Source: $(HTTP https://github.com/Kripth/toml, Kripth/_toml.d)
 * 
 */
module toml;

public import toml.toml : TOML_TYPE, TOMLDocument, TOMLValue, parseTOML, TOMLException, TOMLParserException;
