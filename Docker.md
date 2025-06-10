**Date :** 17-Mar-2025  Monday

**Last modified :** 17-Mar-2025  Monday 14:03 pm

**Status:**   #inprogress 

**Tags:**   [[Docker]] [[Container]] 

---
##  **Docker**

Docker image is a lightweight, standalone, executable package of software that includes everything needed to run an application

## What _is_ Docker?

- "Installing Docker" really means "Installing the Docker Engine and CLI".
    
- The Docker Engine is a daemon (a service running in the background).
    
- This daemon manages containers, the same way that a hypervisor manages VMs.
    
- We interact with the Docker Engine by using the Docker CLI.
    
- The Docker CLI and the Docker Engine communicate through an API.
    
- There are many other programs and client libraries which use that API.



## How running a cmd in the docker works


When you execute `docker version` from the terminal:

- the CLI connects to the Docker Engine over a standard socket,
- the Docker Engine is, in fact, running in a VM,
- ... but the CLI doesn't know or care about that,
- the CLI sends a request using the REST API,
- the Docker Engine in the VM processes the request,
- the CLI gets the response and displays it to you.

All communication with the Docker Engine happens over the API.

This will also allow to use remote Engines exactly as if they were local.


## Docker Images

Docker images are made of layers;
 - each layer can add, change and remove files and/or metadata
 
 ##  When to (not) use tags
 

Don't specify tags:

- When doing rapid testing and prototyping.
- When experimenting.
- When you want the latest version.

Do specify tags:

- When recording a procedure into a script.
- When going to production.
- To ensure that the same version will be used everywhere.
- To ensure repeatability later.

This is similar to what we would do with `pip install`, `npm install`, etc.

## When to use exec syntax and shell syntax

- shell syntax:
    
    - is easier to write
    - interpolates environment variables and other shell expressions
    - creates an extra process (`/bin/sh -c ...`) to parse the string
    - requires `/bin/sh` to exist in the container
- exec syntax:
    
    - is harder to write (and read!)
    - passes all arguments without extra processing
    - doesn't create an extra process
    - doesn't require `/bin/sh` to exist in the container

--- 
### **Reducing size of the image**:

There are various ways of reducing the image:

- **Collapsing Layers :** 
	 - In a docker file each line or an cmd is an layer, 
	 ```Dockerfile
RUN apt-get update           ----layer 1
RUN apt-install <packages>   ----layer 2
```
	- We can also combine both the above layer. by doing this the temp files from both the layer do not get cached in separate layers. hence reducing the size of the image significantly.
	- this would also reduce the readability of the docker file.
	- Also each layer becomes expensive as the layer would consume lot more time to execute.
	
```Dockerfile
RUN apt-get update && apt-install <package>   -----both in one layer
```



- **Building binaries outside the docker file**:

	- in this method rather that building the application inside the container you would build it outside and then code the build context file to the container and then run the file using an compiler.
	- this method would significantly reduce the image size as the image that need to user does not require the tools and dependencies to be installed and also simplify the build process.
	- this would also mean that you would have to maintain an repository for the build context which would increase in size over time with updates.
	- this would also mean that we are to issue that it would work in our machine and not in yours.



- **Squashing the final image**:

	- the method is to squash all the layer in the final image into one.
		- this would mean that only the file system in the final layer would remain.
		
		squashing can be done by below two ways:
		- Activate experimental features and squash the final image:
```bash
docker image build --squash ...
```

- Export/import the final image.

```bash
docker build -t temp-image .
docker run --entrypoint true --name temp-container temp-image
docker export temp-container | docker import - final-image
docker rm temp-container
docker rmi temp-image
```

- **Multi-stage Builds**:

	 - Multi-stage builds allow us to have multiple _stages_.
	- Each stage is a separate image, and can copy files from previous stages.
	- We're going to see how they work in more detail.

---


### **Multi-Stage Builds:**

-  At any point in our `Dockerfile`, we can add a new `FROM` line. This line starts a new stage of our build.
- Each stage can access the files of the previous stages with `COPY --from=...`
- When a build is tagged (with `docker build -t ...`), the last stage is tagged.
- Previous stages are not discarded: they will be used for caching, and can be referenced.
- We need to use a name for the previous stage for it to be referenced with the user of `AS` operator specifying to the location of both from where the file is from and the destination location.

```Dockerfile
FROM golang AS builder

RUN ...

FROM alpine

COPY --from=builder /go/bin/mylittlebinary /usr/local/bin/
```

Example Dockerfile:

```Dockerfile
FROM ubuntu AS compiler

RUN apt-get update

RUN apt-get install -y build-essential

COPY hello.c /

RUN make hello

FROM ubuntu

COPY --from=compiler /hello /hello

CMD /hello
```

```Bash
docker build -t hellomultistage .

docker run hellomultistage
```


By comparing the the file with and without multistage build we can see that:

![[Pasted image 20250610152428.png]]

- We can see the difference in the file size is significant.
- the multistage build is close to the ubuntu image and the image without multistage build is at 449 MB.













## **References**
