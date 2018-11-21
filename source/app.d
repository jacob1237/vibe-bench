import core.stdc.time : time_t;

import vibe.core.core : runApplication;
import vibe.http.server;
import vibe.stream.operations : readAllUTF8;

import asdf;

struct Request
{
	@serializationScoped
	{
		@serializationFlexible
		string id;
		string first_name, last_name;
	}
}

string date(string format, time_t time)
{
	import core.stdc.time : strftime, localtime;
	import std.string : toStringz;

	char[256] buf;
	auto size = strftime(buf.ptr, buf.sizeof, format.toStringz(), localtime(&time));
	return buf[0..size].idup;
}

void handler(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
	import std.digest.md;
	import std.datetime.systime;
	import std.format : format;

	auto data = req.bodyReader
		.readAllUTF8()
		.deserialize!Request;

	res.headers.addField("Content-Type", "application/json");

	res.writeBody(`{"id":%s,"first_name":"%s","last_name":"%s","current_time":"%s","say":"Dlang is the best"}`
		.format(
			data.id,
			"%s %s".format(data.first_name, data.first_name.md5Of.toHexString()),
			"%s %s".format(data.last_name, data.last_name.md5Of.toHexString()),
			date("%F %T %z", Clock.currTime.toUnixTime())
		)
	);
}

void main()
{
	listenHTTP("0.0.0.0:8080", &handler);
	runApplication();
}
