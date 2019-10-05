# GRPC server/client implementation with NodeJS
GRPC server/client implementation using NodeJS with mTLS.

# How to Run.
1. Clone git repo.
2. Generate certs by running node_hello_grpc/node_hello_grpc_server/certs/generate_certs.sh bash script.
3. Run server node_hello_grpc/node_hello_grpc_server/greater_server.js by running
	$ node greater_server
4. Run client node_hello_grpc/node_hello_grpc_server/greater_server.js on a separate terminal by running
	$ node greater_client
	 
* Note: Certs are generated to run server and client on the same machine.

