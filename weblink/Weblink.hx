package weblink;
import haxe.http.HttpMethod;

class Weblink
{
    var server:ServerInternal;
    var func:(request:Request,response:Response)->Void;
    public function new()
    {

    }
    public function get(func:(request:Request,response:Response)->Void)
    {
        this.func = func;
    }
    public function listen(port:Int)
    {
        server = new ServerInternal(port,this);
        //blocking forever
        while (true) server.update();
    }
}