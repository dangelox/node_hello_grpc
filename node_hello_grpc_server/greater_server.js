//Import modules
var fs = require('fs');
var grpc = require('grpc');
var protoLoader = require('@grpc/proto-loader');

//Path to protocol buffer file
var PROTO_PATH = __dirname + '/protos/helloworld.proto';

//Load proto file
var packageDefinition = protoLoader.loadSync(PROTO_PATH, {
	keepCase : true,
	longs : String,
	enums : String,
	defaults : true,
	oneofs : true
});

var hello_proto = grpc.loadPackageDefinition(packageDefinition).helloworld;

//Read CA and server certs
const cacert = fs.readFileSync('certs/ca.crt'), 
	  cert = fs.readFileSync('certs/server.crt'), 
	  key = fs.readFileSync('certs/server.key'), 
	  kvpair = {
		'private_key' : key,
		'cert_chain' : cert
	  };

/**
 * Implements the SayHello RPC method.
 */
function sayHello(call, callback) {
	callback(null, {
		message : 'Hello GRPC ' + call.request.name
	});
}

/**
 * Starts an RPC server that receives requests for the Greeter service at the
 * sample server port
 */
function main() {
	var server = new grpc.Server();
	server.addService(hello_proto.Greeter.service, {
		sayHello : sayHello
	});
	server.bind('0.0.0.0:50051', grpc.ServerCredentials.createSsl(cacert, [kvpair]));

	server.start();
	console.log('Server started @ 0.0.0.0:50051...');
}

//Start server
main();