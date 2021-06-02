FROM golang:alpine
RUN mkdir /app
ADD . /app
WORKDIR /app
## Add this go mod download command to pull in any dependencies
ARG PAT
RUN apk update && apk add git
RUN git config --global url."https://$PAT:x-oauth-basic@github.com/".insteadOf "https://github.com/"
RUN git config --global http.sslVerify false
RUN go get -v -t -d ./...
RUN go mod download
## Our project will now successfully build with the necessary go libraries included.
RUN go build -o main .
## Our start command which kicks off
## our newly created binary executable
CMD ["/app/main"]