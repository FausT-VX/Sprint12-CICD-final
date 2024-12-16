# Satage 1 - Build
FROM golang:1.22 AS build

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go *.db ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o tracker_app .

# Satage 2 - Production
FROM alpine:edge

WORKDIR /app

COPY --from=build /app/tracker_app .
COPY --from=build /app/tracker.db .

ENTRYPOINT ["/app/tracker_app"]