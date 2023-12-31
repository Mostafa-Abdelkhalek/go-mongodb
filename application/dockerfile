FROM golang:1.22rc1-alpine3.19
WORKDIR /app 
COPY . .
RUN go mod verify
RUN go mod download 
RUN go build -o survey .
EXPOSE 8080 
CMD [ "./survey" ]