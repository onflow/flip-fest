## New Tool: Events indexing service - Milestone 4

## Description

This PR is for issue #15

## Submission Links & Documents

Full indexing service:

https://github.com/chriswayoub/flow-scanner

Full example deployment:

https://github.com/chriswayoub/flow-scanner-example


All milestone 4 requirements are met:

* A user can configure the events they wish to watch using a list of Cadence event IDs. The service will continuously monitor all events in this list. The event list can only be changed upon startup — the service does not need to support dynamic configuration (e.g. adding event IDs using an API call).

Use `CADENCE_EVENT_TYPES` in the `.env` file of the example deployment

* The service should watch for events in every block. It can (and should!) use the GetEventsByHeight range to query multiple blocks at once.

This is implemented in the `EventScanner` service

* The service must not miss any events; if a failure occurs in a block, the event indexer should not proceed to the next block until all events have been fetched.

This is handled in various places, notable in the `EventScanner` class and in the `EventBroadcaster` classes

* At a minimum, the service should support event delivery via HTTP webhooks. In this scenario, the consuming application will provide an HTTP endpoint as part of the startup configuration. The consumer should respond with appropriate status consumes to indicate a successful or unsuccessful delivery — these status codes are defined by the indexer.

HTTP delivery is supported as well as SNS and SQS. The architecture allows plugins to be written for any other backend as well.

* The service only needs to support delivery to a single consumer.

Multiple consumers can be configured in a single instance, or multiple instances of the indexer can be run

* All events should be delivered in the same order they were emitted on-chain

This is true, and events are grouped by transactionId if multiple events are being listened for

* Each event should be delivered exactly once. The indexer will need to implement logic to ensure idempotency of events.

This is an optional feature that can be enabled in the service itself, or you can rely on external services to do it (SQS/SNS/etc)

* Message Queueing

Currently supported services are SQS and SNS, and can be extended to additional services easily

* Multiple Consumers

Multiple consumers are supported through the `MulticastEventBroadcaster` configuration
