
var fs = require('fs');
var grpc = require('grpc');
var protoLoader = require('@grpc/proto-loader');

var PROTO_PATH = __dirname + '/protos/helloworld.proto';

var packageDefinition = protoLoader.loadSync(
    PROTO_PATH,
    {keepCase: true,
     longs: String,
     enums: String,
     defaults: true,
     oneofs: true
    });

var hello_proto = grpc.loadPackageDefinition(packageDefinition).helloworld;

const cacert = fs.readFileSync('certs/ca.crt'),
        cert = fs.readFileSync('certs/client.crt'),
        key = fs.readFileSync('certs/client.key'),
        kvpair = {
            'private_key': key,
            'cert_chain': cert
};

function main() {
  var client = new hello_proto.Greeter('bigdata:50051',grpc.credentials.createSsl(cacert, key, cert));

  var user;
  if (process.argv.length >= 3) {
    user = process.argv[2];
  } else {
    user = 'world';
  }
  client.sayHello({name: user}, function(err, response) {
	    console.log('Greeting:', response.message);
	  });

	}

main();

