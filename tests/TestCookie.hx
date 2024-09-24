import haxe.Http;
import weblink.Cookie;
import weblink.Weblink;

using TestingTools;

class TestCookie {
	public static function main() {
		trace("Starting cookie Response Test");
		var app:Weblink;
		var data:String;

		data = haxe.io.Bytes.ofString(Std.string(Std.random(10 * 1000))).toHex();
		app = new Weblink();

		app.get("/", function(request, response) {
			response.cookies.add(new Cookie("foo", "bar"));
			response.send(data);
		});
		app.listenBackground(2000);

		var done = false;
		var http = new Http("http://localhost:2000");
		http.onStatus = status -> {
			if (status != 200) {
				throw "status not OK";
			}
		};
		http.onData = _ -> {
			#if (!nodejs || haxe >= version("4.3.0")) // see #10809
			final headers = http.responseHeaders;
			if (headers.get("Set-Cookie") != "foo=bar") {
				throw 'Set-Cookie not foo=bar. got ${headers.get("Set-Cookie")}';
			}
			#end
			done = true;
		};
		http.request(false);

		#if nodejs
		sys.NodeSync.wait(() -> done);
		#end

		app.close();
		trace("done");
	}
}
